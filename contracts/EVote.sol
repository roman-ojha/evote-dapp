// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;
enum Role {
    admin,
    user
}
struct User {
    address id;
    Role user_type;
    bool does_exist;
}

struct Candidate {
    address id;
    string agenda;
}

struct Voter {
    address id;
}

struct Election {
    uint256 id;
    string name;
    string desc;
    bool is_finished;
    uint256 created_at;
    uint256 start_at;
    uint256 end_at;
    uint256 no_of_voters;
    uint256 no_of_candidates;
    Candidate[] candidates;
    Voter[] voters;
    // mapping(address => Candidate) candidates;
    // mapping(address => Voter) voters;
}

contract EVote {
    mapping(address => User) users;
    // mapping(uint256 => Election) elections;
    Election[] elections;

    constructor() {
        User memory admin = User({
            id: msg.sender,
            user_type: Role.admin,
            does_exist: true
        });
        users[msg.sender] = admin;
    }

    // Authentication
    modifier isUser() {
        require(
            users[msg.sender].does_exist,
            "unauthorized user, please login first"
        );
        _;
    }
    modifier isAdmin() {
        require(
            users[msg.sender].user_type == Role.admin,
            "unauthorized admin, you are not an admin"
        );
        _;
    }

    function login() public {
        if (!users[msg.sender].does_exist) {
            // if user doesn't exist already
            User memory new_user = User({
                id: msg.sender,
                user_type: Role.user,
                does_exist: true
            });
            users[msg.sender] = new_user;
        }
    }

    function get_user() public view isUser returns (User memory) {
        return users[msg.sender];
    }

    function candidate_form() public payable isUser {
        // can access by normal user to request for candidate
        // for that user have to send '0.1' eth
        // users[msg.sender].user_type = user.candidate;
    }

    function am_I_a_candidate() public view isUser returns (bool) {
        // if (users[msg.sender].user_type == user.candidate) {
        //     return true;
        // }
        // return false;
    }

    function create_new_election(
        string memory _name,
        string memory _desc,
        uint256 _start_at_in_days,
        uint256 _end_at_in_days
    ) public isAdmin returns (uint256 _id) {
        // returns: id

        uint256 _start_at = _start_at_in_days * 24 * 60 * 60;
        uint256 _end_at = _end_at_in_days * 25 * 60 * 60;

        // Election memory new_election = Election({
        //     id: elections.length,
        //     name: _name,
        //     desc: _desc,
        //     is_finished: false,
        //     created_at: block.timestamp,
        //     start_at: _start_at,
        //     end_at: _end_at,
        //     no_of_voters: 0,
        //     candidates: new address[](7),
        //     voters: new address[](7)
        // });
        uint256 id = elections.length;
        Election memory new_election;
        new_election.id = id;
        new_election.name = _name;
        new_election.desc = _desc;
        new_election.is_finished = false;
        new_election.created_at = block.timestamp;
        new_election.start_at = _start_at;
        new_election.end_at = _end_at;
        new_election.no_of_voters = 0;
        new_election.no_of_candidates = 0;
        elections.push(new_election);
        return id;
    }

    function get_election(uint256 _id)
        public
        view
        returns (
            string memory name,
            string memory desc,
            bool is_finished,
            uint256 created_at,
            uint256 start_at,
            uint256 end_at,
            uint256 no_of_voters,
            uint256 no_of_candidates,
            Candidate[] memory candidates,
            Voter[] memory voters
        )
    {
        Election storage election = elections[_id];
        return (
            election.name,
            election.desc,
            election.is_finished,
            election.created_at,
            election.start_at,
            election.end_at,
            election.no_of_voters,
            election.no_of_candidates,
            election.candidates,
            election.voters
        );
    }
}
