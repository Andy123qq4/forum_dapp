async function main() {
    // Get signers (Hardhat automatically provides them from the connected network/node)
    const [deployer, user1, user2] = await ethers.getSigners();
    console.log("Using accounts:");
    console.log("  Deployer/Owner:", deployer.address);
    console.log("  User 1:", user1.address);
    console.log("  User 2 (available but not used in this simple scenario):", user2.address);

    // Deploy a new instance of HKUSTForum for this script run
    console.log("\nDeploying a new HKUSTForum contract for this scenario...");
    const HKUSTForumFactory = await ethers.getContractFactory("HKUSTForum");
    const forum = await HKUSTForumFactory.deploy();
    // await forum.deployed(); // Not strictly necessary for local hardhat network script runs with ethers.js v5+
    console.log(`HKUSTForum contract deployed to address: ${forum.address}`);
    
    const initialPostCount = await forum.postCount();
    console.log(`Initial post count (from constructor posts): ${initialPostCount.toString()}`);

    // Scenario: User1 creates a post
    console.log(`\nUser1 (${user1.address}) is creating a new post...`);
    const postContent = "Hello from the Hardhat example script!";
    const postTag = "script-test";
    
    const createPostTx = await forum.connect(user1).createPost(postContent, postTag);
    console.log(`Post creation transaction sent, hash: ${createPostTx.hash}`);
    await createPostTx.wait(); // Wait for the transaction to be mined
    console.log("Post creation transaction confirmed.");

    const currentPostCount = await forum.postCount();
    // Assuming post IDs are sequential and postCount is the ID of the newest post after creation
    const newPostId = currentPostCount; 
    console.log(`New post created. Current total posts: ${currentPostCount.toString()}. ID of new post: ${newPostId.toString()}`);

    console.log(`\nFetching details for Post #${newPostId.toString()}...`);
    const postDetails = await forum.getPost(newPostId);

    console.log("Details of the newly created post:");
    console.log(`  Post ID: ${newPostId.toString()}`); // Explicitly log the ID we used
    console.log(`  Author: ${postDetails.author}`);
    console.log(`  Content: "${postDetails.content}"`);
    console.log(`  Tag: "${postDetails.tag}"`);
    console.log(`  Timestamp: ${new Date(Number(postDetails.timestamp.toString()) * 1000).toLocaleString()}`);
    console.log(`  Is Challenged: ${postDetails.isTagChallenged}`);
    console.log(`  Real Votes: ${postDetails.realVotes.toString()}`);
    console.log(`  Faker Votes: ${postDetails.fakerVotes.toString()}`);
    console.log(`  Comment Count: ${postDetails.commentCount.toString()}`);

    console.log("\nExample scenario script finished successfully.");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("Script failed:", error);
        process.exit(1);
    }); 