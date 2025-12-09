// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TutorMarketplace {
    enum SessionStatus { Requested, Accepted, Completed, Confirmed, Disputed, Resolved }

    address public admin;
    uint public sessionCounter = 0;

    struct Session {
        uint id;
        address payable student;
        address payable tutor;
        uint amount;
        SessionStatus status;
        string topic;
    }

    mapping(uint => Session) public sessions;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    event SessionRequested(uint id, address student, address tutor, uint amount);
    event SessionAccepted(uint id);
    event SessionRejected(uint id);
    event SessionCompleted(uint id);
    event SessionConfirmed(uint id);
    event DisputeOpened(uint id);
    event DisputeResolved(uint id, string decision);

    function requestSession(address payable _tutor, string memory _topic) public payable {
        require(msg.value > 0, "Payment required");
        sessions[sessionCounter] = Session(
            sessionCounter,
            payable(msg.sender),
            _tutor,
            msg.value,
            SessionStatus.Requested,
            _topic
        );
        emit SessionRequested(sessionCounter, msg.sender, _tutor, msg.value);
        sessionCounter++;
    }

    function acceptSession(uint _id) public {
        Session storage s = sessions[_id];
        require(msg.sender == s.tutor, "Only tutor can accept");
        require(s.status == SessionStatus.Requested, "Invalid status");
        s.status = SessionStatus.Accepted;
        emit SessionAccepted(_id);
    }

    function rejectSession(uint _id) public {
        Session storage s = sessions[_id];
        require(msg.sender == s.tutor, "Only tutor can reject");
        require(s.status == SessionStatus.Requested, "Invalid status");
        s.status = SessionStatus.Resolved;
        s.student.transfer(s.amount);
        emit SessionRejected(_id);
    }

    function markCompleted(uint _id) public {
        Session storage s = sessions[_id];
        require(msg.sender == s.tutor, "Only tutor");
        require(s.status == SessionStatus.Accepted, "Invalid status");
        s.status = SessionStatus.Completed;
        emit SessionCompleted(_id);
    }

    function confirmSession(uint _id) public {
        Session storage s = sessions[_id];
        require(msg.sender == s.student, "Only student");
        require(s.status == SessionStatus.Completed, "Not completed yet");
        s.status = SessionStatus.Confirmed;
        s.tutor.transfer(s.amount);
        emit SessionConfirmed(_id);
    }

    function openDispute(uint _id) public {
        Session storage s = sessions[_id];
        require(msg.sender == s.student, "Only student");
        require(s.status == SessionStatus.Completed, "Must be completed first");
        s.status = SessionStatus.Disputed;
        emit DisputeOpened(_id);
    }

    function resolveDispute(uint _id, bool refundToStudent) public onlyAdmin {
        Session storage s = sessions[_id];
        require(s.status == SessionStatus.Disputed, "No dispute");
        s.status = SessionStatus.Resolved;
        if (refundToStudent) {
            s.student.transfer(s.amount);
            emit DisputeResolved(_id, "Refunded to student");
        } else {
            s.tutor.transfer(s.amount);
            emit DisputeResolved(_id, "Paid to tutor");
        }
    }
}
