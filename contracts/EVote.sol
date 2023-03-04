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
    bool does_exist;
    uint256 no_of_votes;
}

struct Voter {
    address id;
    bool does_exist;
    address voted_for;
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
    // Candidate[] candidates;
    // Voter[] voters;
    mapping(address => Candidate) candidates;
    address[] candidatesAddress;
    mapping(address => Voter) voters;
    address[] votersAddress;
    address won_by;
}

struct ResponseMsg {
    uint256 status;
    string message;
}

contract EVote {
    address payable admin;
    mapping(address => User) users;
    // mapping(uint256 => Election) elections;
    Election[] elections;
    uint256 public candidate_form_fee = 100 wei;

    constructor() {
        User memory new_admin = User({
            id: msg.sender,
            user_type: Role.admin,
            does_exist: true
        });
        users[msg.sender] = new_admin;
        admin = payable(msg.sender);
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
            users[msg.sender].does_exist &&
                users[msg.sender].user_type == Role.admin,
            "unauthorized admin, you are not an admin"
        );
        _;
    }

    function login() external {
        if (!users[msg.sender].does_exist) {
            // if user doesn't exist already
            User memory new_user = User({
                id: msg.sender,
                user_type: Role.user,
                does_exist: true
            });
            users[msg.sender] = new_user;
        }

        // return ResponseMsg({status: 200, message: "Login Successfully"});
    }

    function get_user() public view isUser returns (User memory) {
        return users[msg.sender];
    }

    function check_admin() public view isAdmin returns (User memory) {
        return users[msg.sender];
    }

    function create_new_election(
        string memory _name,
        string memory _desc,
        uint256 _start_after_in_days,
        uint256 _end_after_in_days
    ) public isAdmin returns (uint256 _id) {
        // returns: id

        uint256 _start_at = block.timestamp + (_start_after_in_days * 1 days);
        uint256 _end_at = block.timestamp +
            ((_start_after_in_days + _end_after_in_days) * 1 days);

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
        elections.push();
        Election storage new_election = elections[id];
        new_election.id = id;
        new_election.name = _name;
        new_election.desc = _desc;
        new_election.is_finished = false;
        new_election.created_at = block.timestamp;
        new_election.start_at = _start_at;
        new_election.end_at = _end_at;
        new_election.no_of_voters = 0;
        new_election.no_of_candidates = 0;
        return id;
    }

    // function to get info about election
    function get_election_info(uint256 _election_id)
        public
        returns (
            string memory name,
            string memory desc,
            bool is_finished,
            uint256 created_at,
            uint256 start_at,
            uint256 end_at,
            uint256 no_of_voters,
            uint256 no_of_candidates,
            address won_by
        )
    {
        if (elections[_election_id].end_at < block.timestamp) {
            // while checking if we find out that election end time exceed in that case we will finish the election
            elections[_election_id].is_finished = true;
        }

        Election storage election = elections[_election_id];
        return (
            election.name,
            election.desc,
            election.is_finished,
            election.created_at,
            election.start_at,
            election.end_at,
            election.no_of_voters,
            election.no_of_candidates,
            election.won_by
        );
    }

    function candidate_form(uint256 _election_id, string memory _agenda)
        public
        payable
        isUser
    {
        // can access by normal user to request for candidate
        // for that user have to send '0.1' eth
        require(
            msg.value >= candidate_form_fee,
            "please submit with at least 100 wei"
        );
        // no need to create candidate if it already exist
        require(
            !elections[_election_id].candidates[msg.sender].does_exist,
            "you are already a candidate, no need to fill form two times"
        );

        if (elections[_election_id].end_at < block.timestamp) {
            // while checking if we find out that election end time exceed in that case we will finish the election
            elections[_election_id].is_finished = true;
        }

        // to create for for the candidate first election should not had finished
        require(
            !elections[_election_id].is_finished,
            "election that you choose is already finished"
        );

        Candidate memory candidate = Candidate({
            id: msg.sender,
            agenda: _agenda,
            does_exist: true,
            no_of_votes: 0
        });
        elections[_election_id].candidates[msg.sender] = candidate;
        elections[_election_id].no_of_candidates++;
        // add candidate address into candidatesAddress array
        // it help to get all the Candidate[]
        elections[_election_id].candidatesAddress.push(msg.sender);
    }

    function am_I_a_candidate(uint256 _election_id)
        public
        view
        isUser
        returns (bool)
    {
        if (elections[_election_id].candidates[msg.sender].does_exist) {
            return true;
        }
        return false;
    }

    // function to transfer balance from contract to admin
    function transfer_balance_to_admin() public isAdmin {
        uint256 contract_balance = address(this).balance;
        admin.transfer(contract_balance);
    }

    // function to get admin balance
    function get_admin_balance() public view isAdmin returns (uint256) {
        return address(msg.sender).balance;
    }

    // function to return contract balance
    function get_contract_balance() public view isAdmin returns (uint256) {
        return address(this).balance;
    }

    // function to get all the candidates with given election id
    function get_candidates(uint256 _election_id)
        public
        view
        isUser
        returns (Candidate[] memory)
    {
        Election storage election = elections[_election_id];
        uint256 no_of_candidates = election.no_of_candidates;
        Candidate[] memory candidates = new Candidate[](no_of_candidates);
        for (uint256 i = 0; i < no_of_candidates; i++) {
            candidates[i] = election.candidates[election.candidatesAddress[i]];
        }
        return candidates;
    }

    // function to get info about single candidate using given election id
    function get_candidate(uint256 _election_id, address _candidate_address)
        public
        view
        isUser
        returns (Candidate memory)
    {
        // candidate should exist
        require(
            elections[_election_id].candidates[_candidate_address].does_exist,
            "given candidate doesn't exist"
        );
        return elections[_election_id].candidates[_candidate_address];
    }

    // function to vote
    function vote(uint256 _election_id, address _candidate_address)
        public
        isUser
    {
        // voter should not already have voted
        require(
            !elections[_election_id].voters[msg.sender].does_exist,
            "you have already voted for this election"
        );

        // candidate should exist
        require(
            elections[_election_id].candidates[_candidate_address].does_exist,
            "given candidate doesn't exist"
        );

        if (elections[_election_id].end_at < block.timestamp) {
            // while checking if we find out that election end time exceed in that case we will finish the election
            elections[_election_id].is_finished = true;
        }

        // to vote for the candidate first election should not have finished
        require(
            !elections[_election_id].is_finished,
            "election that you choose is already finished"
        );

        // to vote fo the candidate first election should get started
        require(
            elections[_election_id].start_at < block.timestamp,
            "election is not started yet"
        );

        Voter memory voter = Voter({
            id: msg.sender,
            does_exist: true,
            voted_for: _candidate_address
        });
        elections[_election_id].voters[msg.sender] = voter;
        elections[_election_id].no_of_voters++;
        elections[_election_id].candidates[_candidate_address].no_of_votes++;
    }

    // function to publish result
    // max is index
    // there could be multiple candidate having same max voters
    uint256[] max;

    function choose_winner(uint256 _election_id)
        public
        returns (address won_by)
    {
        Election storage election = elections[_election_id];

        require(
            election.end_at < block.timestamp,
            "the election process has not been completed"
        );

        if (election.no_of_candidates == 0 || election.no_of_voters == 0) {
            return address(0);
        }

        max.push(0);
        for (uint256 i = 1; i < election.no_of_candidates; i++) {
            uint256 max_votes = election
                .candidates[election.candidatesAddress[max[0]]]
                .no_of_votes;
            uint256 current_candidate_votes = election
                .candidates[election.candidatesAddress[i]]
                .no_of_votes;
            if (current_candidate_votes > max_votes) {
                max = new uint256[](0);
                max.push(i);
            } else if (current_candidate_votes == max_votes) {
                max.push(i);
            }
        }
        address winner = address(0);
        if (max.length == 1) {
            // single winner
            winner = election.candidatesAddress[max[0]];
        } else if (max.length > 1) {
            // choose winner randomly
            winner = election.candidatesAddress[
                max[random_number(max.length - 1)]
            ];
        }
        election.won_by = winner;
        return winner;
    }

    function random_number(uint256 _up_to) private view returns (uint256) {
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, msg.sender, block.number)
            )
        ) % (_up_to + 1);

        return random;
    }
}
