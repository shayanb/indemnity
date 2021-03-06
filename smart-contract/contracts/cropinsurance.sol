pragma solidity >=0.4.22 <0.6.0;

contract CropInsurance {

    struct Plot {
        uint plotId;
        address owner;
    }
    
    struct InsuranceRequest {
        uint insuranceRequestId;
        uint plotId;
        uint startDate;
        uint endDate;
        uint premium;
        uint coverRequired;
        address insuredParty;
    }
    
    struct Policy {
        uint policyId;
        uint insuranceRequestId;
        address insuredParty;
        uint collateral;
        uint premium;
        uint startDate;
        uint endDate;
        uint claimDate;
        mapping(address => uint) collateralLiabilities;
        mapping(address => uint) premiumDividends;
        mapping(address => bool) premiumDividendPayouts;
    }
    
    struct Tranche {
        uint trancheId;
        address payable seller;
        uint policyId;
        uint collateralLiabilityChange;
        uint premiumDividendChange;
        bool sold;
    }
    
    mapping(address => bool) public verifiers; //TODO: verifiers should be structs that can do more . like multisignature
    Plot[] public plots;
    InsuranceRequest[] public insuranceRequests;
    Policy[] public policies;
    Tranche[] public tranches;
    
    modifier ownsPlot(uint plotId) {
        require(msg.sender == plots[plotId].owner, "restricted to plot owner");
        _;
    }
    
    modifier policyExists(uint policyId) {
        require(policies[policyId].policyId != 0, "cannot find policy");
        _;
    }
    
    modifier isPolicyProvider(uint policyId) {
        require(policies[policyId].collateralLiabilities[msg.sender] != 0, "no collateral stake found in policy");
        require(policies[policyId].premiumDividends[msg.sender] != 0, "no premium dividend found in policy");
        _;
    }
    
    event InsuranceRequestSubmitted(uint indexed insuranceRequestId, uint indexed plotId, address indexed insuredParty, uint startDate, uint endDate, uint premium, uint coverRequired);
    
    event InsuranceRequestCancelled(uint indexed insuranceRequestId);
    
    event ClaimSubmitted(uint indexed policyId);
    
    event CoverProvided(uint indexed insuranceRequestId);
    
    event PolicyPremiumDividendOffered(uint indexed collateralLiabilityChange, uint indexed premiumDividendChange, uint policyExpiryDate, uint policyId,uint trancheId);
    
    event PolicyPremiumDividendSaleCancelled(uint indexed trancheId);
    
    event PolicyPremiumDividendBought(uint indexed tranchId);
    
    event PolicyPremiumPayoutRequested(uint indexed policyId);
    
    event PlotAdded(string PlotName,uint PlotId);
    
    event TraunchCreated(uint tranchId);
    
    address Contractowner;
    constructor() public{
    Contractowner = msg.sender;
    
    //dummy plot
    plots.push(Plot({
            plotId: 0,
            owner: msg.sender
        }));
    //dummy insurance id
    insuranceRequests.push(InsuranceRequest({
            insuranceRequestId: 0,
            plotId: 0,
            startDate: 0,
            endDate: 0,
            premium: 0,
            coverRequired: 0,
            insuredParty: msg.sender
        }));
        
    policies.push(Policy({
            policyId: 0,
            insuranceRequestId: 0,
            insuredParty: msg.sender,
            collateral: 0,
            premium: 0,
            startDate: 0,
            endDate: 0,
            claimDate: 0
        }));
        
    tranches.push(Tranche(0, msg.sender, 0,0,0, false));
    }
    /** @dev Allows owner to add plots.
      * @param plotname name of the plot.
      * @param plotowner Address of the owner of the plot.
      * @return plotIndex, identifier for the plot the farmer wants to insure 
      */
    function addPlot(string memory plotname,address plotowner) public returns(uint){
    require(msg.sender==Contractowner,"only owner can add plots");
    uint PlotIndex = plots.length;
    plots.push(Plot({
            plotId: (PlotIndex),
            owner: plotowner
        }));
    emit PlotAdded(plotname,PlotIndex);
    
    }
    
    
    /** @dev Allows farmer to submit a request for insurance cover.
      * @param plotIndex The plot the farmer wants to insure.
      * @param startDate The date the cover commences, more than policy can exist for a plot, but cannot overlap.
      * @param endDate The date the will policy expire, must be after start date.
      * @param premium The amount the farmer is willing to pay for this insurance cover, must be sent with transaction, and will be locked for duration of policy.
      * @return insuranceRequestId , the id to reference to this request
      */
    function submitInsuranceRequest(uint plotIndex, uint startDate, uint endDate, uint premium, uint coverRequired) public payable ownsPlot(plotIndex) returns (uint){
        require(plots[plotIndex].plotId != 0, "Plot index does not exist");
        require(plots[plotIndex].owner == msg.sender, "Only plot owner can request coverage");
        require(msg.value == premium, "premium must be paid");
        require(premium < coverRequired, "coverRequired should be more than the premium");
        require(startDate >= now, "startDate should not be in the past");
        require(endDate > startDate, "endDate should be after startDate");
        require((endDate - startDate) < 365 days, "Duration of the request should be less than 1 year");
        
        uint insuranceRequestId = insuranceRequests.length;
        insuranceRequests.push(InsuranceRequest({
            insuranceRequestId: insuranceRequestId,
            plotId: plotIndex,
            startDate: startDate,
            endDate: endDate,
            premium: premium,
            coverRequired: coverRequired,
            insuredParty: msg.sender
        }));
        
        emit InsuranceRequestSubmitted(insuranceRequestId, plotIndex, msg.sender, startDate, endDate, premium, coverRequired);
        return (insuranceRequestId);
    }
    
    /** @dev Allows farmer to cancel a request for insurance that they submitted, so long as request has not been filled.
      * @param insuranceRequestId The id of the insurance request to cancel.
      */
    function cancelInsuranceRequest(uint insuranceRequestId) public ownsPlot(insuranceRequests[insuranceRequestId].plotId) {
        require(insuranceRequests[insuranceRequestId].insuranceRequestId != 0, "insuranceRequestId does not exist");
        require(policies.length<=insuranceRequestId, "There is already a policy assigned to this request");
        
        insuranceRequests[insuranceRequestId].insuranceRequestId = 0;
        //TODO: maybe replace ^ with "delete insuranceRequests[insuranceRequestId]"
    
        emit InsuranceRequestCancelled(insuranceRequestId);
    }
  
    /** @dev Allows a provider to respond to a request for insurance cover by providing collateral to cover claim payouts.
      * @param insuranceRequestId The id of the insurance request to provide cover for.
      * @return policyId
      */
    function provideCover(uint insuranceRequestId) public payable returns (uint) {
        require(insuranceRequests[insuranceRequestId].insuranceRequestId != 0, "insuranceRequestId does not exist");
        require(policies.length<=insuranceRequestId, "There is already a policy assigned to this request");
        require(insuranceRequests[insuranceRequestId].startDate > now, "Cover cannot be issued once start date has passed");
        require(msg.value == insuranceRequests[insuranceRequestId].coverRequired, "deposit should be equal to requests coverRequired");
        require(msg.sender != insuranceRequests[insuranceRequestId].insuredParty, "Cannot insure your own request");

        InsuranceRequest memory proposal = insuranceRequests[insuranceRequestId];
        //TODO: make sure ^ results in the right request, no off by 1 errors
    
        uint policyId = policies.length;
    
        policies.push(Policy({
            policyId: policyId,
            insuranceRequestId: insuranceRequestId,
            insuredParty: proposal.insuredParty,
            collateral: proposal.coverRequired,
            premium: proposal.premium,
            startDate: proposal.startDate,
            endDate: proposal.endDate,
            claimDate: 0
        }));
        
        policies[policyId].collateralLiabilities[msg.sender]=proposal.coverRequired;
        policies[policyId].premiumDividends[msg.sender]=proposal.premium;
        
        emit CoverProvided(insuranceRequestId);
        return (policyId);
    }
    
      
    /** @dev Allows farmer to submit a claim and receive payout.
      * @param policyId The id of the insurance policy under which farmer is making claim.
      * @param hash The hash of the message that is sighned by verifier.
      * @param v The v attribute of signature, for signature protection.
      * @param r The r attribute of signature, from which entropy was derived.
      * @param s The s attribute of the signature.
      */
    function submitClaim(uint policyId, bytes32 hash, uint8 v, bytes32 r, bytes32 s) public policyExists(policyId) {
        require(msg.sender == policies[policyId].insuredParty, "only insuredParty can send this request");
        require(policies[policyId].endDate >= now, "Policy should not be expired");
        require(policies[policyId].claimDate == 0, "Only one claim can be made on policy; policy is invalid thereafter");
        require(verifiers[ecrecover(hash, v, r, s)] == true, "only approved verifiers signature are valid");
        //TODO: replay protection! now one valid verifier signature is valid for all other policies!!!

        policies[policyId].claimDate = now;

        //TODO: maybe do more checks for transfer. e.g. what if transfer fails?
        //both premium and collateral transferred to insurance buyer
        msg.sender.transfer(policies[policyId].collateral);
        msg.sender.transfer(policies[policyId].premium);
        
        emit ClaimSubmitted(policyId);
    }
    

    //TODO: if we mint a NFT for the policies the below logic should be changed to NFT interface
    
    /** @dev Allows a provider to all or part of a policy they are providing cover for.
      * @param collateralLiabilityChange The amount of collateral the provider is currently providing, that will be replaced by buyer.
      * @param premiumDividendChange The amount of the premiums the provider is currently getting, that will be transfered to buyer.
      * @param policyId The id of the insurance policy in which the premiums dividends are being sold.
      */
    function sellPolicyPremiumDividend(uint collateralLiabilityChange, uint premiumDividendChange, uint policyId) public payable policyExists(policyId) isPolicyProvider(policyId) {
        require(policies[policyId].collateralLiabilities[msg.sender] > collateralLiabilityChange);
        require(policies[policyId].premiumDividends[msg.sender] > premiumDividendChange);
        uint trancheid=tranches.length;
        tranches.push(Tranche(trancheid, msg.sender, policyId, collateralLiabilityChange, premiumDividendChange, false));
        
        emit PolicyPremiumDividendOffered(collateralLiabilityChange, premiumDividendChange, policies[policyId].endDate, policyId,trancheid);
        
    }
    
    /** @dev Allows a provider to cancel an ask for a premium dividend sale, before it has been bought.
      * @param trancheId The id of the tranche sale to cancel.
      */
    function cancelPolicyPremiumDividendSale(uint trancheId) public {
        require(msg.sender == tranches[trancheId].seller);
        require(tranches[trancheId].sold != true);
        
        tranches[trancheId].trancheId = 0;
        
        emit PolicyPremiumDividendSaleCancelled(trancheId);
    }
    
    /** @dev Allows a other provider to buy a tranche that has put up for sale.
      * @param trancheId The id of the tranche sale to buy.
      */
    function buyPolicyPremiumDividend(uint trancheId) public payable {
        require(tranches[trancheId].trancheId != 0);
        require(tranches[trancheId].sold != true);
        require(msg.value == tranches[trancheId].collateralLiabilityChange,"Collateral amount should match the buy");
        require(msg.sender != tranches[trancheId].seller,"seller cannot buy his own sell request");
        
        tranches[trancheId].sold = true;
        
        Tranche memory tranche = tranches[trancheId];
        
        policies[tranche.policyId].collateralLiabilities[tranche.seller] -= tranche.collateralLiabilityChange;
        policies[tranche.policyId].collateralLiabilities[msg.sender] = tranche.collateralLiabilityChange;
        
        policies[tranche.policyId].premiumDividends[tranche.seller] -= tranche.premiumDividendChange;
        policies[tranche.policyId].premiumDividends[msg.sender] = tranche.premiumDividendChange;
        
        tranche.seller.transfer(tranche.collateralLiabilityChange);
        
        emit PolicyPremiumDividendBought(trancheId);
    }
    
    /** @dev Allows a provider to collect the premium dividends from a policy that has expired without claim.
      * @param policyId The id of the policy to collect premiums from.
      */
    function requestPolicyPremiumPayout(uint policyId) public policyExists(policyId) isPolicyProvider(policyId) {
        require(policies[policyId].endDate < now);
        require(policies[policyId].claimDate == 0);
        require(policies[policyId].premiumDividendPayouts[msg.sender] != true);
        require(policies[policyId].premiumDividends[msg.sender]!=0);

        policies[policyId].premiumDividendPayouts[msg.sender] = true;
        
        //both premium and collateral corresponding to insurance provider ownership stake sent to IP
        msg.sender.transfer(policies[policyId].premiumDividends[msg.sender]);
        msg.sender.transfer(policies[policyId].collateralLiabilities[msg.sender]);

        emit PolicyPremiumPayoutRequested(policyId);
    }
}

