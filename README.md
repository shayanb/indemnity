# Indemnity
Blockchain Insurance Project - an [initc3](https://www.initc3.org/events/2019-06-10-IC3-Blockchain-Boot-Camp.html) Ethereum bootcamp project


# Blockchain Insurance Specs

This is an MVP for Crop Insurance ecosystem.

### Key points:
- Anyone can launch/propose
- Collateral would be deposited by the Insurance Buyer (Farmer), Insurance provider will match it. 

## Actors
- Insurance Providers/Issuers (Create their own risk models/assessment)
- Farmers (Insurance buyers, Pools)
- Oracles (To prove/verify the outcome)
- Insurance Traders

## Plot Registry
- Plot ID will be used for insurance ASK
- Mapping (Off-chain or on-chain)
- 
-------------------------------

## Workflow


### 1. Insurance Proposal
Farmer would send send a request `ASK`/`Proposal` providing the following:
  - Plot of land (Location X)
    - for Y Dollars (Per Acre/Unit)
  - Premium (Per Unit) (Unit * Premium) ($$$ ETH) ~~(Collateralize)~~
  - Total Payout (Per Unit)
  - {Approved Oracles}
  - Expiry date

The `ASK` orders will be listed in an `orderbook`. 

### 2. Insurance Provider Accepts Proposal
Insurance providers will come and accept proposals the desire from the `orderbook`: 
  - Match Payout (Total Payout per Unit * Number of Units) ~~Collateral~~ ($$$ ETH)


### 3. Expiry
Assuming no (successful) claim have been submitted in the period of the contract and the expiry date has reached.
  - `Now > Expiry`
  - The request to the Oracles is initiated by either the Farmer or the insurance provider
  - Oracle approves that there has been no losses / (Or Claim process follows)
    - Binary for now: Yes or No (Yes --> Payout, No --> Claim Process)
  - If (No Failure) --> Payment to Insurance provider (Payout + Premium)
  - If (Yes Failure) --> Payment to Farmer (Payout)


### 4. Claim Process




**Notes:**
- `Unit` here is either Acre or KM^2
- In the next versions, this process will be replaced with a bidding process.



## Questions for later
- Payment to Oracles
- Bidding on insurance proposals
- Land Plots (Geography)
- Oracle can send a non-binary response (e.g. 80% of the crops have failed)
- 

## TODO:
- Workflow for executing the contract
  - With percentage Payout
  - Without Payout
- A lot more


## Possible Oracles (Trusted):
- Satellite data
- Trusted evaluation firms
- Sensors

If k out of N oracles approve, then Payout. 




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

