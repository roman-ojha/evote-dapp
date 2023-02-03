// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

struct Admin {
    address payable id;
}

enum user {
    candidate,
    voter
}
struct User {
    address id;
    user user_type;
    bool does_exist;
}

contract EVote {
    Admin admin;
    mapping(address => User) users;

    constructor() {
        admin.id = payable(msg.sender);
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
            admin.id == msg.sender,
            "unauthorized admin, you are not an admin"
        );
        _;
    }

    function login() public {
        if (!users[msg.sender].does_exist) {
            // if user doesn't exist already
            User memory new_user = User({
                id: msg.sender,
                user_type: user.voter,
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
        users[msg.sender].user_type = user.candidate;
    }

    function am_I_a_candidate() public view isUser returns (bool) {
        if (users[msg.sender].user_type == user.candidate) {
            return true;
        }
        return false;
    }

    function add_candidate() public view {}
}
