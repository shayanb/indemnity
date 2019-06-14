# Crop Insurance on Blockchain
A 2019 [initc3](https://www.initc3.org/events/2019-06-10-IC3-Blockchain-Boot-Camp.html) bootcamp project, built on Ethereum. 


# Overview

The following documentation outlines an MVP for a peer to peer crop insurance ecosystem, powered by Ethereum. The objective of this MVP is to drive a holistically enhanced customer experience by enabling direct connectivity between demand-side (Insurance Buyers) and supply-side (Insurance Providers) participants and ensuring guaranteed, timely payouts of premiums and policies when applciable.  

Additionally, this MVP serves to demonstrate the coexistence of a robust, seamless secondary trading marketplace for digital insurance contracts, and the benefits of facilitating that marketplace on the same rails utilized for the primary creation process. 

### Scope of MVP:
- Policy Creation: Initial request of a new insurance policy and establishment of terms by an Insurance Buyer, acceptance of terms by an Insurance Provider 
- Claim Submission: 
- Policy Expiry: 
- Trading: 

This MVP does not yet address: bidding, matching, partial crop failures, premium & payout reinvestment options, market-making, among other functionalities. See below for further discussion. 

## Actors
- Insurance Buyers: Farmers and landowners looking to purchase crop insurance to protect against the event of failed harvests
    - Note: farmers could independently insure their crops through this market, or pool assets to unlock lower premiums 
- Insurance Providers: Independent actuaries and smaller insurance companies who can provide coverage to Insurance Buyers in the event of crop failure and generate revenue from premiums in the absence of crop failure. Their decision to engage in the market is typically based on an assesment of risk factors, an analysis process that's typically unique to each provider. 
- Oracles: data sources that are trusted sources to verify the outcome of whether or not a crop has failed
    - Note: Oracles are not required to directly participate in the network in this MVP 
- Insurance Traders: Insurance Providers can be Insurance Traders
    - Motivations for trading can be varied, most notably including: diversification of risk, definite profit opportunities  


## Plot Registry
- Plot ID will be used for insurance ASK
- Mapping (Off-chain or on-chain)
- 
-------------------------------

## Workflow


### 1. Policy Creation
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



# Board Sketches
![Board V 0.0.1](assets/img/board-1.jpg "Board V 0.0.1")

![Board V 0.0.2](assets/img/board-2.jpg "Board V 0.0.2")





