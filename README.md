# Crop Insurance on Blockchain
A 2019 [initc3](https://www.initc3.org/events/2019-06-10-IC3-Blockchain-Boot-Camp.html) bootcamp project, built on Ethereum. 

**Slides**: https://docs.google.com/presentation/d/1esDRIJ6rhfc185wXPz6Q08MYKb9XoIUcYrCvQlrSdNI/edit?usp=sharing

**Live Demo**: https://shayanb.github.io/indemnity/index.html


# Overview

The following documentation outlines an MVP for a peer to peer crop insurance ecosystem, powered by Ethereum. The objective of this MVP is to drive a holistically enhanced customer experience by enabling direct connectivity between demand-side (Insurance Buyers) and supply-side (Insurance Providers) participants and ensuring guaranteed, timely payouts of premiums and policies when applciable.  

Additionally, this MVP serves to demonstrate the coexistence of a robust, seamless secondary trading marketplace for digital insurance contracts, and the benefits of facilitating that marketplace on the same rails utilized for the primary creation process. 

### Scope of MVP:
- Policy Creation: An Insurance Buyer submits an initial request for a new insurance policy that includes all desired terms; Insurance Providers view the requests and determine if they choose to accept the requests. 

- Claim Submission: Insurance Buyers submit off-chain claims to the chosen Oracle, requesting a determination that total crop failure has occurred prior to policy expiry. Oracles either reject the claim, or provide the Insurance Buyer with a signed message, indicating that total crop failure has occured. 

- Policy Expiry: 

- Trading: 

This MVP does not yet address: plot and land registries, bidding, matching, partial crop failures, premium & payout reinvestment options, market-making, among other functionalities. See below for further discussion. Payments are currently made in ETH; however, a future-state version may require the use of a more stable currency, or at least the ability to specify alternatives. 

## Actors
- **Insurance Buyers:** Farmers and landowners looking to purchase crop insurance to protect against the event of failed harvests
    - Note: farmers could independently insure their crops through this market, or pool assets to unlock lower premiums 
    
- **Insurance Providers:** Independent actuaries and smaller insurance companies who can provide coverage to Insurance Buyers in the event of crop failure and generate revenue from premiums in the absence of crop failure. Their decision to engage in the market is typically based on an assesment of risk factors, an analysis process that's typically unique to each provider. 

- **Oracles:** trusted data sources that can verify the outcome of whether or not a crop has failed
    - Note: Oracles are not required to directly participate in the network within this MVP
    - Potential oracles: 
        - Satellite data
        - Trusted evaluation firms
        - Sensors
        
- **Insurance Traders:** Insurance Providers can be Insurance Traders
    - Motivations for trading can be varied, most notably including: diversification of risk, definite profit opportunities  

-------------------------------

## Workflow


### 1. Policy Creation
Actors: Insurance Buyer, Insurance Trader

Conditions: *need to fill in*

Process:  

A Farmer will create a proposal for insuring a plot of their land, then submit to the Insurance Provider marketplace. The proposal contains the following terms: 

- Plot ID - one plot ID per proposal (Specified within plot registry: Total Size (km2) - total area covered by all plots included within contract)
- Start Date - when the policy would start
- End Date - when the policy would expire
- Premium (ETH / km2) - amount per km2 paid by the farmer for the insurance protection in the event that crop failure does not occur 
- Payout (ETH / km2) - amount per km2 of protection that the farmer seeks and would be guaranteed by an insurance provider in the event of crop failure 
- Approved Oracle(s) - approved data provider(s) who will be ultimately responsible for verifying any claims of failure up till and including expiry; corresponds to a whitelist of approved and trusted public keys 

At submission, the farmer also transfers the total premium amount (ETH) to the proposal.

Before the submitted proposal is confirmed, there is a check to ensure that the submitter (the Farmer) is the listed owner of that plot

The premium sits within the proposal and away from the farmer, but remains unlocked (farmer is able to withdraw), and the terms of the proposal can be modified accordingly, until the proposal is accepted by an Insurance Provider. 

An Insurance Provider will be able to view the proposal and choose to accept. At acceptance, the Insurance Provider also commits (sends) the total payout amount ($) to the proposal. 

Once accepted, and the funds from the Insurance Provider are deposited, the proposal is complete and is a fully formed contract or policy. 


### 2. Claim Submission
Actors: Insurance Buyer, Oracle

Conditions: 

*Need to complete*
- Insurance contract is still valid
- Current date must be equal to or less than date of expiry 

Process:

The Farmer will contact the Oracle, indicating they are raising an insurance claim, and request for a verification of the state of the Plot(s). This communication will take place off-chain. 

The Oracle will address the following question: has total crop failure occurred for the total plot within this contract? This determination (i.e. analysis of data) will take place off-chain. 

   - If NO (total crop failure has not occurred): the workflow is complete. 

   - If YES (total crop failure has occurred): The Oracle will then sign a transaction indicating Yes (total crop failure has occurred) with their trusted private key. This transaction will be submitted to the network by the farmer. 
        - There will be an automated verification process, confirming that the signature provided by the Oracle does, indeed, match one of the pre-specified trusted public keys (a determination made originally within the Farmer’s proposal). This will occur on-chain. 
        - Total payout and total premium are released to the Farmer
        - The Insurance Policy is no longer valid 


### 3. Expiry
Actors: Insurance Provider

*Need to complete*

Conditions: 
- Current date is after expiry date
- Policy ID exists 
- Requester is a listed insurance provider with stake in the policy; their stake still exists
- No claims have been made on this policy
- Message sender has not previously withdrawn funds from this contract

After expiry date, if no claims have been made and both payout and premium exist within the contract, the Insurance Provider will be able to withdraw funds from the contract. The Insurance Provider will submit a transaction requesting this withdrawal, and if all conditions are met, both premium and payout is sent to the Insurance Provider, in accordance with their ownership stake in thep policy.  

### 4. Trading
Actors: Insurance Provider, Insurance Trader

*Need to edit*
Conditions: 
Insurance contract is still valid
Current date must be equal to or less than date of expiry

Workflow:
The Insurance Provider (Existing Holder) seeks to exit their total position or percentage of their position held within an Insurance Policy. 

The Insurance Provider (Existing Holder) will create a request to sell, specifying: 
- Change in Payout (ETH) - This is effectively the price of the trade. Trade settlement completes once the Insurance Trader deposits this amount into the Insurance Policy, and the same amount is withdrawn and transferred to the Insurance Provider, decreasing their liability position within the policy in the event of crop failure. This number must be equal to or less than the total payout amount of the policy.

- Change in Premium (ETH) - This amount corresponds to the change in ownership stake that the Insurance Provider has in the total premium. After trade settlement, this amount would be owed to the Insurance Trader instead of the Insurance Provider in the event crop failure. 

The Insurance Provider would then submit the request to the marketplace. 

The Insurance Trader (another Insurance provider) who seeks to enter into or expand position within the same Insurance Policy would accept the terms of the trade. In doing so, the Insurance Trader must send the total amount corresponding to the price of the transfer (ETH) to the Insurance Contract. That same amount is then released from the contract and sent to the Insurance Provider. The ownership positions are updated accordingly. The Insurance Trader is now a listed Insurance Provider within the policy. 

## Future-State
- Plot Registries
- Bidding
- Insurance Provider proposals + Matching engine
- Partial crop failures
- Exchange and market-making tools
- Premium and payout reinvestment options
- More flexibility with Oracles (i.e. approval rules - k of N Oracle approvals, etc.) 


# Security Consideration
- Oracles 
- Double Indemnity
- Payout safety


# API Design

## Data Structures

```
struct plot {
    uint plotId;
    address owner;
}
```

```
struct insuranceRequest {
    uint plotId;
    uint startDate;
    uint endDate;
    uint premium;
    unit coverRequired;
}
```

```
struct policy {
    uint policyId;
    mapping(address => uint) collateralLiabilities;
    mapping(address => uint) premiumDividends;
    mapping(address => boolean) premiumDividendPayouts;
    uint startDate;
    uint endDate;
}
```

```
struct tranche {
    address seller;
    uint collateralLiabilityChange;
    boolean sold;
}
```

```
public plot[] plots;
public insuranceRequest[] insuranceRequests;
public policy[] policies;
public tranche[] tranches;
```

## Functions

* **submitInsuranceRequest**
  * plotId, startDate, endDate, premium, coverRequired

    * require(plots[plotId] != 0)
    * require(msg.sender == plots[plotId].owner)
    * require(msg.value == premium)
    * require(premium < coverRequired)
    * require(startDate > now)
    * require(endDate > startDate)
    * require(endDate - startDate < 365 days)

* **cancelInsuranceRequest**
  * insuranceRequestId

    * require(insuranceRequests[insuranceRequestId] != 0)
    * require(policies[insuranceRequestId] == 0)
    * require(msg.sender == plots[plotId].owner)

 * **submitClaim**
   * policyId, claimAmount

     * require(policies[policyId] != 0)
     * require(msg.sender == policies[policyId].insuredParty)
     * require(policies[policyId].endDate > now)
     * require(verifiers[ecrecover(hash, v, r, s)] != 0)
     * require(policies[policyId].claimAmount <= policies[policyId].totalCollateral)

 * **provideCover**
   * insuranceRequestId

     * require(insuranceRequests[insuranceRequestId] != 0)
     * require(msg.value == insuranceRequests[insuranceRequestId].coverRequired)
     * require(msg.sender != insuranceRequests[insuranceRequestId].insuredParty)

 * sellPolicyPremiumDividend
   * collateralLiabilityChange, premiumDividendChange, policyId

     * require(policies[policyId] != 0)
     * require(policies[policyId].collateralLiabilities[msg.sender] != 0)
     * require(policies[policyId].premiumDividends[msg.sender] != 0)
     * require(policies[policyId].collateralLiabilities[msg.sender] > collateralLiabilityChange)
     * require(policies[policyId].premiumDividends[msg.sender] > premiumDividendChange)

 * **cancelPolicyPremiumDividendSale**
   * trancheId

     * require(msg.sender == tranches[trancheId].seller)
     * require(tranches[trancheId].sold != true)


 * **buyPolicyPremiumDividend**
   * tracheId

      * require(tranches[trancheId] != 0)
      * require(tranches[trancheId].sold != true)
      * require(msg.value == tranches[tranchId].collateralLiabilityChange)
      * require(msg.sender != tranches[trancheId].seller)

 * **requestPolicyPremiumPayout**
   * policyId

     * require(policies[policyId] != 0)
     * require(policies[policyId].endDate < now)
     * require(policies[policyId].collateralLiabilities[msg.sender] != 0)
     * require(policies[policyId].premiumDividends[msg.sender] != 0)
     * require(policies[policyId].premiumDividendPayouts[msg.sender] != true)

# Diagrams

![Tranche Sale Workflow](https://i.ibb.co/CKcMY8S/blockchain-insurance-Page-1.png)

![Tranche Sale Workflow](https://i.ibb.co/dbLmZRw/blockchain-insurance-Page-3.png)

![Tranche Sale Workflow](https://i.ibb.co/NpXgtKH/crop-grower-dashboard.png)

![Tranche Sale Workflow](https://i.ibb.co/sFgJSyM/Screenshot-2019-06-14-at-02-52-23.png)

