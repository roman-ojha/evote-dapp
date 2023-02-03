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

struct Election {
    uint256 id;
    string name;
    string desc;
    bool is_finished;
    uint256 created_at;
    uint256 start_at;
    uint256 end_at;
    uint256 no_of_voters;
    mapping(address => User) candidate;
}

contract EVote {
    mapping(address => User) users;
    uint256 no_of_election;
    mapping(uint256 => Election) elections;

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
    ) public isAdmin {
        no_of_election++;
        uint256 _start_at = _start_at_in_days * 24 * 60 * 60;
        uint256 _end_at = _end_at_in_days * 25 * 60 * 60;

        // Election memory new_election = Election({
        //     id: no_of_election,
        //     name: _name,
        //     desc: _desc,
        //     is_finished: false,
        //     created_at: block.timestamp,
        //     start_at: _start_at,
        //     end_at: _end_at
        //     no_of_voters:0,
        // });

        Election storage new_election = elections[no_of_election];
        new_election.id = no_of_election;
        new_election.name = _name;
        new_election.desc = _desc;
        new_election.is_finished = false;
        new_election.created_at = block.timestamp;
        new_election.start_at = _start_at;
        new_election.end_at = _end_at;
        new_election.no_of_voters = 0;
    }
}
