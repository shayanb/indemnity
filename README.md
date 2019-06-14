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

This MVP does not yet address: bidding, matching, partial crop failures, premium & payout reinvestment options, market-making, among other functionalities. See below for further discussion. Payments are currently made in ETH; however, a future-state version may require the use of a more stable currency, or at least the ability to specify alternatives. 

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
Conditions: *need to fill in*

Process:  

A Farmer will create a proposal for insuring a plot of their land, then submit to the Insurance Provider marketplace. The proposal contains the following terms: 

- Plot ID - one plot ID per proposal (Specified within plot registry: Total Size (km2) - total area covered by all plots included within contract)
- Start Date
- End Date
- Premium (ETH / km2) - amount per km2 paid by the farmer for the insurance protection in the event that crop failure does not occur 
- Payout (ETH / km2) - amount per km2 of protection that the farmer seeks and would be guaranteed by an insurance provider in the event of crop failure 
- Approved Oracle(s) - approved data provider(s) who will be ultimately responsible for verifying any claims of failure up till and including expiry; corresponds to a whitelist of approved and trusted public keys 

At submission, the farmer also transfers the total premium amount (ETH) to the proposal.

Before the submitted proposal is confirmed, there is a check to ensure that the submitter (the Farmer) is the listed owner of that plot

The premium sits within the proposal and away from the farmer, but remains unlocked (farmer is able to withdraw), and the terms of the proposal can be modified accordingly, until the proposal is accepted by an Insurance Provider. 

An Insurance Provider will be able to view the proposal and choose to accept. At acceptance, the Insurance Provider also commits (sends) the total payout amount ($) to the proposal. 

Once accepted, and the funds from the Insurance Provider are deposited, the proposal is complete and is a fully formed contract or policy. 


### 2. Claim Submission
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
*Need to complete*

### 4. Trading
*Need to edit*
Conditions: 
Insurance contract is still valid
Current date must be equal to or less than date of expiry

Workflow:
The Insurance Provider (Existing Holder) seeks to exit their total position or percentage of their position held within an Insurance Contract 

The Insurance Trader (another Insurance provider) seeks to enter into or expand position within the same Insurance Contract

The Insurance Trader will specify the: 
- Ownership position that will transfer from Provider to Trader 
- Price of the transfer ($)

The Insurance Provider and Insurance Trader will both sign a transaction agreeing to the terms of the trade. The transaction is then submitted to the network. 

To finalize the trade, the Insurance Trader must commit (send) the total amount corresponding to the price of the transfer ($) to the Insurance Contract. That same amount is then released from the contract and sent to the Insurance Provider. The ownership positions are then updated accordingly. 




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





