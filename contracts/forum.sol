// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HKUSTForum {
    // ==================== Constants ====================
    uint256 private constant MAX_BATCH_SIZE = 20; // Maximum batch size for comment retrieval

    // ==================== Structs ====================
    struct Post {
        address author;
        string content; // Direct content storage instead of hash
        string tag;
        uint256 timestamp;
        bool isTagChallenged;
        uint256 realVotes;
        uint256 fakerVotes;
        mapping(address => bool) hasVoted;
        uint256 commentCount;
    }

    struct Comment {
        address author;
        string content;
        string tag; // Added tag field for comments
        uint256 timestamp;
    }

    // ==================== State variables ====================
    mapping(uint256 => Post) public posts;
    uint256 public postCount;
    // Comments: postId => commentId => Comment
    mapping(uint256 => mapping(uint256 => Comment)) public comments;
    
    // ==================== Events ====================
    event PostCreated(uint256 indexed postId, address indexed author, string tag, string content);
    event TagChallenged(uint256 indexed postId, address indexed challenger);
    event VoteCast(uint256 indexed postId, address indexed voter, bool isRealVote);
    event CommentAdded(uint256 indexed postId, uint256 indexed commentId, address indexed author, string content, string tag);
    
    // Add them for every redeployment
    // ==================== Constructor ====================
    constructor() {
        // Manually create post with specific values
        // Increment post count for the first post
        postCount = 1;
        
        // ==================== Post #1 ====================
        // Hardcode exact values for the post
        Post storage newPost = posts[postCount];
        newPost.author = 0x4511277f98BA4282705Da1c250110E24Aa2f88a2;
        newPost.content = "test";
        newPost.tag = "student";
        newPost.timestamp = 1746874632;  // Using the specific timestamp
        newPost.isTagChallenged = false;
        newPost.realVotes = 0;
        newPost.fakerVotes = 0;
        newPost.commentCount = 1;  // Set to 1 to indicate we'll add a comment
        
        // Add a sample comment to this post
        Comment storage newComment = comments[postCount][1];
        newComment.author = 0x4511277f98BA4282705Da1c250110E24Aa2f88a2;
        newComment.content = "This is a sample comment on the test post";
        newComment.tag = "student";
        newComment.timestamp = 1746874700;  // Slightly later timestamp for the comment
        
        // Emit events for the post and comment creation
        emit PostCreated(postCount, newPost.author, newPost.tag, newPost.content);
        emit CommentAdded(postCount, 1, newComment.author, newComment.content, newComment.tag);
        
        // ==================== Post #2 ====================
        // Create post #2 matching the screenshot
        postCount++;
        Post storage post2 = posts[postCount];
        post2.author = 0x4511277f98BA4282705Da1c250110E24Aa2f88a2;
        post2.content = "the COMP4511 project will be canceled!";
        post2.tag = "professor";
        post2.timestamp = 1746874800;  // 5/10/2025, 8:58:24 PM
        post2.isTagChallenged = true;
        post2.realVotes = 0;
        post2.fakerVotes = 1;
        post2.commentCount = 3;  // Has three comments
        
        // Add the comment 1
        Comment storage comment2 = comments[postCount][1];
        comment2.author = 0x4511277f98BA4282705Da1c250110E24Aa2f88a2;
        comment2.content = "No way! I can finally be free from the project!";
        comment2.tag = "student";
        comment2.timestamp = 1746875000;

        // Add the second comment to post #2 disputing the claim
        Comment storage comment2_2 = comments[postCount][2];
        comment2_2.author = 0x3fC91A3afd70395Cd496C647d5a6CC9D4B2b7FAD;
        comment2_2.content = "This is definitely fake news. Don't believe it.";
        comment2_2.tag = "student";
        comment2_2.timestamp = 1746875200;
        
        // Add the third comment to post #2 challenging the poster's identity
        Comment storage comment2_3 = comments[postCount][3];
        comment2_3.author = 0xa983d7E14AC1aAf050bb64Fdab1024ae9c93c956;
        comment2_3.content = "How can you pretend to be a professor and then comment as a student? Our project is still ongoing. We should challenge this user's credibility!";
        comment2_3.tag = "student";
        comment2_3.timestamp = 1746882492;
        
        emit PostCreated(postCount, post2.author, post2.tag, post2.content);
        emit CommentAdded(postCount, 1, comment2.author, comment2.content, comment2.tag);
        emit CommentAdded(postCount, 2, comment2_2.author, comment2_2.content, comment2_2.tag);
        emit CommentAdded(postCount, 3, comment2_3.author, comment2_3.content, comment2_3.tag);

        // ==================== Post #3 ====================
        // Create post #3 
        postCount++;
        Post storage post3 = posts[postCount];
        post3.author = 0x4511277f98BA4282705Da1c250110E24Aa2f88a2; 
        post3.content = "The escalator outside CYT is broken again! Please fix it urgently!";
        post3.tag = "student";
        // May 10, 2025, 7:14:36 PM in Unix timestamp
        post3.timestamp = 1747098876; 
        post3.isTagChallenged = false;
        post3.realVotes = 0;
        post3.fakerVotes = 0;
        post3.commentCount = 2;  // Updated to 2 comments

        // Add the first comment
        Comment storage comment3 = comments[postCount][1];
        comment3.author = 0x3fC91A3afd70395Cd496C647d5a6CC9D4B2b7FAD; // Different author for the comment
        comment3.content = "Thank you for reporting this issue. We'll send a maintenance team right away.";
        comment3.tag = "staff"; // The commenter selected "Staff" from the dropdown
        comment3.timestamp = 1747099000; // A timestamp shortly after the post

        // Add the second comment from a professor
        Comment storage comment3_2 = comments[postCount][2];
        comment3_2.author = 0xa983d7E14AC1aAf050bb64Fdab1024ae9c93c956;
        comment3_2.content = "Thank you to the staff for the quick response! This has been an ongoing issue.";
        comment3_2.tag = "professor";
        comment3_2.timestamp = 1746882408;

        emit PostCreated(postCount, post3.author, post3.tag, post3.content);
        emit CommentAdded(postCount, 1, comment3.author, comment3.content, comment3.tag);
        emit CommentAdded(postCount, 2, comment3_2.author, comment3_2.content, comment3_2.tag);

        // ==================== Post #4 ====================
        // Create post #4
        postCount++;
        Post storage post4 = posts[postCount];
        post4.author = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB; 
        post4.content = "When will LG1 open new meal options?";
        post4.tag = "staff";
        // May 15, 2025, 10:30:00 AM in Unix timestamp
        post4.timestamp = 1746886600; 
        post4.isTagChallenged = true;
        post4.realVotes = 0;
        post4.fakerVotes = 3;
        post4.commentCount = 3;  // 3 comments

        // Add the first comment from student
        Comment storage comment4 = comments[postCount][1];
        comment4.author = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        comment4.content = "This person is not staff. I've seen them around campus as a student.";
        comment4.tag = "student";
        comment4.timestamp = 1746887700; // A timestamp shortly after the post

        // Add the second comment from another student
        Comment storage comment4_2 = comments[postCount][2];
        comment4_2.author = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;
        comment4_2.content = "I agree, definitely not staff. Voting fake on this one.";
        comment4_2.tag = "student";
        comment4_2.timestamp = 1746888800;
        
        // Add the third comment from another student
        Comment storage comment4_3 = comments[postCount][3];
        comment4_3.author = 0xa983d7E14AC1aAf050bb64Fdab1024ae9c93c956;
        comment4_3.content = "I know this person from my class. They're pretending to be staff!";
        comment4_3.tag = "student";
        comment4_3.timestamp = 1746889900;

        emit PostCreated(postCount, post4.author, post4.tag, post4.content);
        emit CommentAdded(postCount, 1, comment4.author, comment4.content, comment4.tag);
        emit CommentAdded(postCount, 2, comment4_2.author, comment4_2.content, comment4_2.tag);
        emit CommentAdded(postCount, 3, comment4_3.author, comment4_3.content, comment4_3.tag);
    }
    
    // ==================== Internal Functions ====================
    // Internal function to create initial posts with a comment
    function _createInitialPost(string memory _content, string memory _tag, string memory _initialComment) internal {
        // Increment post count
        postCount++;
        
        // Create new post
        Post storage newPost = posts[postCount];
        newPost.author = msg.sender;
        newPost.content = _content;
        newPost.tag = _tag;
        newPost.timestamp = block.timestamp;
        newPost.isTagChallenged = false;
        newPost.realVotes = 0;
        newPost.fakerVotes = 0;
        newPost.commentCount = 1; // Start with one comment
        
        // Add initial comment
        Comment storage newComment = comments[postCount][1];
        newComment.author = msg.sender;
        newComment.content = _initialComment;
        newComment.tag = _tag; // Use the same tag as the post for initial comment
        newComment.timestamp = block.timestamp;
        
        // Emit events
        emit PostCreated(postCount, msg.sender, _tag, _content);
        emit CommentAdded(postCount, 1, msg.sender, _initialComment, _tag);
    }

    // ==================== External Functions ====================
    function createPost(string memory _content, string memory _tag) external {
        // Increment post count
        postCount++;
        
        // Create new post
        Post storage newPost = posts[postCount];
        newPost.author = msg.sender;
        newPost.content = _content;
        newPost.tag = _tag;
        newPost.timestamp = block.timestamp;
        newPost.isTagChallenged = false;
        newPost.realVotes = 0;
        newPost.fakerVotes = 0;
        newPost.commentCount = 0;
        
        // Emit event
        emit PostCreated(postCount, msg.sender, _tag, _content);
    }
    
    function addComment(uint256 _postId, string memory _content, string memory _tag) external {
        require(_postId > 0 && _postId <= postCount, "Invalid post ID");
        require(bytes(_content).length > 0, "Comment cannot be empty");
        
        Post storage post = posts[_postId];
        post.commentCount++;
        
        Comment storage newComment = comments[_postId][post.commentCount];
        newComment.author = msg.sender;
        newComment.content = _content;
        newComment.tag = _tag;
        newComment.timestamp = block.timestamp;
        
        emit CommentAdded(_postId, post.commentCount, msg.sender, _content, _tag);
    }
    
    // ==================== View Functions ====================
    function getComment(uint256 _postId, uint256 _commentId) external view returns (
        address author,
        string memory content,
        string memory tag,
        uint256 timestamp
    ) {
        require(_postId > 0 && _postId <= postCount, "Invalid post ID");
        require(_commentId > 0 && _commentId <= posts[_postId].commentCount, "Invalid comment ID");
        
        Comment storage comment = comments[_postId][_commentId];
        return (
            comment.author,
            comment.content,
            comment.tag,
            comment.timestamp
        );
    }
    
    function getCommentsBatch(uint256 _postId, uint256 _startId, uint256 _batchSize) external view returns (
        address[] memory authors,
        string[] memory contents,
        string[] memory tags,
        uint256[] memory timestamps,
        uint256 totalCount
    ) {
        require(_postId > 0 && _postId <= postCount, "Invalid post ID");
        require(_startId > 0, "Start ID must be greater than 0");
        
        uint256 commentCount = posts[_postId].commentCount;
        totalCount = commentCount;
        
        // If start ID is greater than comment count, return empty arrays
        if (_startId > commentCount) {
            return (new address[](0), new string[](0), new string[](0), new uint256[](0), totalCount);
        }
        
        // Limit batch size for gas efficiency
        uint256 batchSize = _batchSize;
        if (batchSize > MAX_BATCH_SIZE) {
            batchSize = MAX_BATCH_SIZE;
        }
        
        // Calculate actual batch size based on available comments
        uint256 remainingComments = commentCount - _startId + 1;
        if (batchSize > remainingComments) {
            batchSize = remainingComments;
        }
        
        authors = new address[](batchSize);
        contents = new string[](batchSize);
        tags = new string[](batchSize);
        timestamps = new uint256[](batchSize);
        
        for (uint256 i = 0; i < batchSize; i++) {
            uint256 commentId = _startId + i;
            Comment storage comment = comments[_postId][commentId];
            
            authors[i] = comment.author;
            contents[i] = comment.content;
            tags[i] = comment.tag;
            timestamps[i] = comment.timestamp;
        }
        
        return (authors, contents, tags, timestamps, totalCount);
    }
    
    function getCommentCount(uint256 _postId) external view returns (uint256) {
        require(_postId > 0 && _postId <= postCount, "Invalid post ID");
        return posts[_postId].commentCount;
    }
    
    // ==================== Tag Challenge Functions ====================
    // Merge challengeTag and vote functions
    function challengeAndVote(uint256 _postId, bool _isRealVote) external {
        require(_postId > 0 && _postId <= postCount, "Invalid post ID");
        Post storage post = posts[_postId];
        
        // Check if the tag is already challenged
        if (!post.isTagChallenged) {
            // This is a new challenge
            require(post.author != msg.sender, "Cannot challenge your own post");
            
            post.isTagChallenged = true;
            emit TagChallenged(_postId, msg.sender);
        }
        
        // Now proceed with the vote
        require(!post.hasVoted[msg.sender], "Already voted");
        require(post.author != msg.sender, "Cannot vote on your own post");
        
        post.hasVoted[msg.sender] = true;
        
        if (_isRealVote) {
            post.realVotes++;
        } else {
            post.fakerVotes++;
            
            // Removed automatic invalidation based on threshold
            // Now invalidation would need to be done manually by admin or through separate process
        }
        
        emit VoteCast(_postId, msg.sender, _isRealVote);
    }

    // ==================== Post Data Functions ====================
    // View functions to get post data (since we can't return structs with mappings)
    function getPost(uint256 _postId) external view returns (
        address author,
        string memory content,
        string memory tag,
        uint256 timestamp,
        bool isTagChallenged,
        uint256 realVotes,
        uint256 fakerVotes,
        uint256 commentCount
    ) {
        require(_postId > 0 && _postId <= postCount, "Invalid post ID");
        Post storage post = posts[_postId];
        
        return (
            post.author,
            post.content,
            post.tag,
            post.timestamp,
            post.isTagChallenged,
            post.realVotes,
            post.fakerVotes,
            post.commentCount
        );
    }
    
    function hasVoted(uint256 _postId, address _voter) external view returns (bool) {
        require(_postId > 0 && _postId <= postCount, "Invalid post ID");
        return posts[_postId].hasVoted[_voter];
    }
} 