const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("HKUSTForum - Voting", function () {
    let HKUSTForumFactory; // Renamed to avoid conflict with contract instance variable
    let forum;
    let owner, user1, user2, user3; // Signers
    let initialPostCount;

    beforeEach(async function () {
        // Get signers
        [owner, user1, user2, user3] = await ethers.getSigners();

        // Deploy the contract
        HKUSTForumFactory = await ethers.getContractFactory("HKUSTForum");
        forum = await HKUSTForumFactory.deploy();
        // await forum.deployed(); // Not strictly necessary with Hardhat Network, but good practice for other networks

        // Get the initial post count from the constructor
        initialPostCount = await forum.postCount(); 
        // console.log("Initial post count from constructor:", initialPostCount.toString());
    });

    // Test cases will go here

    it("should allow a user to cast a real vote on a post, emit events, and update state", async function () {
        // 1. user1 creates a new post
        await forum.connect(user1).createPost("Test content for voting", "testtag");
        const newPostId = await forum.postCount(); // This will be initialPostCount + 1
        // console.log("New Post ID for testing:", newPostId.toString());

        // 2. user2 casts a real vote on this new post
        const tx = await forum.connect(user2).voteOnTag(newPostId, true);

        // 3. Assertions
        // Check events
        await expect(tx)
            .to.emit(forum, "VoteCast")
            .withArgs(newPostId, user2.address, true);
        await expect(tx)
            .to.emit(forum, "TagChallenged")
            .withArgs(newPostId, user2.address);

        // Check post state
        const post = await forum.getPost(newPostId);
        expect(post.realVotes).to.equal(1);
        expect(post.fakerVotes).to.equal(0);
        expect(post.isTagChallenged).to.be.true;

        // Check if user2 is marked as voted
        expect(await forum.hasVoted(newPostId, user2.address)).to.be.true;
    });

    it("should prevent a user from voting twice on the same post", async function () {
        // 1. user1 creates a new post
        await forum.connect(user1).createPost("Test content for double vote", "testtag2");
        const postId = await forum.postCount();

        // 2. user2 casts a first vote (real vote)
        await forum.connect(user2).voteOnTag(postId, true);

        // 3. user2 attempts to cast another vote (fake vote this time)
        await expect(forum.connect(user2).voteOnTag(postId, false))
            .to.be.revertedWith("Already voted");
        
        // Optional: Verify vote counts haven't changed from the first vote
        const post = await forum.getPost(postId);
        expect(post.realVotes).to.equal(1); // From the first successful vote
        expect(post.fakerVotes).to.equal(0);
    });

    it("should prevent a user from voting on their own post", async function () {
        // 1. user1 creates a new post
        await forum.connect(user1).createPost("Test content for own post vote", "testtag3");
        const postId = await forum.postCount();

        // 2. user1 attempts to vote on their own post
        await expect(forum.connect(user1).voteOnTag(postId, true))
            .to.be.revertedWith("Cannot vote on your own post");

        // Optional: Verify vote counts are still zero and tag is not challenged
        const post = await forum.getPost(postId);
        expect(post.realVotes).to.equal(0);
        expect(post.fakerVotes).to.equal(0);
        expect(post.isTagChallenged).to.be.false;
    });
}); 