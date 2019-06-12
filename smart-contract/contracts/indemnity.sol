pragma solidity ^0.5.5;

import "./plot_registry.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";


contract indemnity is plotRegistry {

    using SafeMath for uint;

    uint planIndex;

    enum PlanStatus {Proposed, Accepted, Expired}
    struct plan {
        uint plot_id;
        uint premium;
        uint payout;
        address payable proposer;
        address payable insurer;
        PlanStatus status;
    }

    mapping (uint => plan) public plans; //plan_id -> plan

    event PlanProposed(uint indexed plan_id, bytes32 indexed plot_id, address proposer, uint premium, uint payout);
    event PlanAccepted(uint indexed plan_id, bytes32 indexed plot_id, address insurer, uint deposit);
   // Farmer propose a plan to insure his/her plot 
   // ::plot_id:: is the plot id from plotRegistry
   // ::premium:: is the premium per surfaceUnit that should be paid in the terms of the plan
   // ::payout:: is the payout per surfaceUnit that the insurance provider should match
    function proposePlan(uint plot_id, uint premium, uint payout) external payable returns (uint plan_id) {
        require(plots[plot_id] != 0, "Plot_id does not exist");
        require(plots[plot_id].owner == msg.sender, "You are not plot_id's owner");
        require(msg.value >= premium.mul(plots[plot_id].surfaceArea));
        
        planIndex += 1 ;

        plans[planIndex] = plan(plot_id, premium, payout, msg.sender, 0, PlanStatus.Proposed);

        emit PlanProposed(planIndex, plot_id, msg.sender, premium, payout);
        return planIndex;

    }


    // Insurance providers can accept a proposed plan
   // ::plan_id:: is the plan id of the proposed plan (plans)
    function AcceptProposal(uint plan_id) external payable returns (bool){
        require(plans[plan_id] != 0, "Plan does not exist");
        require(plans[plan_id].status == PlanStatus.Proposed, "Plan is not in Proposed State");
        require(msg.value >= plans[plan_id].payout.mul(plots[plans[plan_id].plot_id].surfaceAre));

        plans[plan_id].insurer = msg.sender;
        plans[plan_id].status = PlanStatus.Accepted;

        emit PlanAccepted(plan_id, plans[plan_id].plot_id, msg.sender, uint msg.value);
        return true;
    }

}