# meetup


## tranches - view
|name |type |description
|-----|-----|-----------
||uint256|
**Add Documentation for the method here**

## submitInsuranceRequest - read
|name |type |description
|-----|-----|-----------
|plotIndex|uint256|The plot the farmer wants to insure.
|startDate|uint256|The date the cover commences, more than policy can exist for a plot, but cannot overlap.
|endDate|uint256|The date the will policy expire, must be after start date.
|premium|uint256|The amount the farmer is willing to pay for this insurance cover, must be sent with transaction, and will be locked for duration of policy.
|coverRequired|uint256|
Allows farmer to submit a request for insurance cover.

## requestPolicyPremiumPayout - read
|name |type |description
|-----|-----|-----------
|policyId|uint256|The id of the policy to collect premiums from.
Allows a provider to collect the premium dividends from a policy that has expired without claim.

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
|trancheId|uint256|The id of the tranche sale to cancel.
Allows a provider to cancel an ask for a premium dividend sale, before it has been bought.

## cancelInsuranceRequest - read
|name |type |description
|-----|-----|-----------
|insuranceRequestId|uint256|The id of the insurance request to cancel.
Allows farmer to cancel a request for insurance that they submitted, so long as request has not been filled.

## submitClaim - read
|name |type |description
|-----|-----|-----------
|policyId|uint256|The id of the insurance policy under which farmer is making claim.
|hash|bytes32|The hash of the message that is sighned by verifier.
|v|uint8|The v attribute of signature, for signature protection.
|r|bytes32|The r attribute of signature, from which entropy was derived.
|s|bytes32|The s attribute of the signature.
Allows farmer to submit a claim and receive payout.

## policies - view
|name |type |description
|-----|-----|-----------
||uint256|
**Add Documentation for the method here**

## buyPolicyPremiumDividend - read
|name |type |description
|-----|-----|-----------
|trancheId|uint256|The id of the tranche sale to buy.
Allows a other provider to buy a tranche that has put up for sale.

## sellPolicyPremiumDividend - read
|name |type |description
|-----|-----|-----------
|collateralLiabilityChange|uint256|The amount of collateral the provider is currently providing, that will be replaced by buyer.
|premiumDividendChange|uint256|The amount of the premiums the provide will collect, that will noe eb transfered to buyer.
|policyId|uint256|The id of the insurance policy in which the premiums dividends are being sold.
Allows a provider to all or part of a policy they are providing cover for.

## provideCover - read
|name |type |description
|-----|-----|-----------
|insuranceRequestId|uint256|The id of the insurance request to provide cover for.
Allows a provider to respond to a request for insurance cover by providing collateral to cover claim payouts.

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
