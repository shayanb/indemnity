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

-------------------------------

## Workflow

Farmer would send send a request `ASK` providing the following:
    - Plot of land (Location X)
      - for Y Dollars (Per Acre/Unit)
    - Collateralize ($$$ ETH)
    - Premium 
    - Total Payout
    - {Approved Oracles}
    - Expiry date

The `ASK` orders will be listed in an `orderbook`. Insurance providers will come and take orders by filling them with matching Collateral. 

In the next versions, this process will be replaced with a bidding process.



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


![Board V 0.0.1](assets/img/board-1.jpg "Board V 0.0.1")



# Security Consideration
- Oracles 
- Double Indemnity
- Payout safety







