# meetup


## tranches - view
|name |type |description
|-----|-----|-----------
||uint256|
**Add Documentation for the method here**

## submitInsuranceRequest - read
|name |type |description
|-----|-----|-----------
|plotIndex|uint256|
|startDate|uint256|
|endDate|uint256|
|premium|uint256|
|coverRequired|uint256|
**Add Documentation for the method here**

## requestPolicyPremiumPayout - read
|name |type |description
|-----|-----|-----------
|policyId|uint256|
**Add Documentation for the method here**

## plots - view
|name |type |description
|-----|-----|-----------
||uint256|
**Add Documentation for the method here**

## verifiers - view
|name |type |description
|-----|-----|-----------
||address|
**Add Documentation for the method here**

## cancelPolicyPremiumDividendSale - read
|name |type |description
|-----|-----|-----------
|trancheId|uint256|
**Add Documentation for the method here**

## cancelInsuranceRequest - read
|name |type |description
|-----|-----|-----------
|insuranceRequestId|uint256|
**Add Documentation for the method here**

## submitClaim - read
|name |type |description
|-----|-----|-----------
|policyId|uint256|
|hash|bytes32|
|v|uint8|
|r|bytes32|
|s|bytes32|
**Add Documentation for the method here**

## policies - view
|name |type |description
|-----|-----|-----------
||uint256|
**Add Documentation for the method here**

## buyPolicyPremiumDividend - read
|name |type |description
|-----|-----|-----------
|trancheId|uint256|
**Add Documentation for the method here**

## sellPolicyPremiumDividend - read
|name |type |description
|-----|-----|-----------
|collateralLiabilityChange|uint256|
|premiumDividendChange|uint256|
|policyId|uint256|
**Add Documentation for the method here**

## provideCover - read
|name |type |description
|-----|-----|-----------
|insuranceRequestId|uint256|
**Add Documentation for the method here**

## insuranceRequests - view
|name |type |description
|-----|-----|-----------
||uint256|
**Add Documentation for the method here**

## InsuranceRequestSubmitted - read
|name |type |description
|-----|-----|-----------
|plotId|uint256|
|insuredParty|address|
|startDate|uint256|
|endDate|uint256|
|premium|uint256|
|coverRequired|uint256|
**Add Documentation for the method here**

## InsuranceRequestCancelled - read
|name |type |description
|-----|-----|-----------
|insuranceRequestId|uint256|
**Add Documentation for the method here**

## ClaimSubmitted - read
|name |type |description
|-----|-----|-----------
|policyId|uint256|
**Add Documentation for the method here**

## CoverProvided - read
|name |type |description
|-----|-----|-----------
|insuranceRequestId|uint256|
**Add Documentation for the method here**

## PolicyPremiumDividendOffered - read
|name |type |description
|-----|-----|-----------
|collateralLiabilityChange|uint256|
|premiumDividendChange|uint256|
|policyExpiryDate|uint256|
|policyId|uint256|
**Add Documentation for the method here**

## PolicyPremiumDividendSaleCancelled - read
|name |type |description
|-----|-----|-----------
|trancheId|uint256|
**Add Documentation for the method here**

## PolicyPremiumDividendBought - read
|name |type |description
|-----|-----|-----------
|tranchId|uint256|
**Add Documentation for the method here**

## PolicyPremiumPayoutRequested - read
|name |type |description
|-----|-----|-----------
|policyId|uint256|
**Add Documentation for the method here**
