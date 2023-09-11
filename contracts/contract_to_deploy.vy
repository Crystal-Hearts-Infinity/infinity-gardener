#@version ^0.3.7

"""
1) Charity entities are allowed to deploy Smart Contract to raise fund based 
on needs from donors.
2) Beneficiary has to work hard to complete the milestone, for example, plant 
trees and earn Carb tokens, representing carbon credits, to claim the fund 
from the Smart Contract.
"""

from vyper.interfaces import ERC20

funding_goal:public(uint256)
donors:HashMap[address,uint256]
charity:public(address)
start_time:public(uint256)
donation_deadline:public(uint256) 
beneficiary: address
milestone: public(uint256)
milestone_deadline:public(uint256)
DAO_treasury: constant(address) = 0x7C074007b72c398C488526753739efFD092586e7
Carbon_token: constant(address) = 0x62997d381a5EF9fAC9ba2b22c3f10b45053DaB12

@external
def __init__(charity: address,_funding_goal:uint256, _funding_time:uint256, 
        _beneficiary:address,_milestone:uint256,_time:uint256):
    self.charity = msg.sender
    self.funding_goal =_funding_goal
    self.beneficiary =_beneficiary
    self.start_time = block.timestamp
    self.donation_deadline = self.start_time + _funding_time
    self.milestone_deadline = self.donation_deadline + _time
    self.milestone =_milestone
#    self.DAO_treasury = '0x7C074007b72c398C488526753739efFD092586e7'
#    self.Carbon_token = '0x62997d381a5EF9fAC9ba2b22c3f10b45053DaB12'

@external
def setup(_masterCopy: address, charity: address,_funding_goal:uint256,
        funding_time:uint256, _beneficiary:address,_milestone:uint256,_time:uint256): 
    """ Set up the contract """
    self.charity = msg.sender
    self.funding_goal =_funding_goal
    self.beneficiary =_beneficiary
    self.start_time = block.timestamp
    self.donation_deadline = self.start_time + _funding_time
    self.milestone_deadline = self.donation_deadline + _time
    self.milestone = _milestone

@external
@payable
def donate():
    assert block.timestamp >= self.start_time, "donation not start yet"
    msg_donation_period_ended = ("donation period has ended, thank you "
            "for your interest")
    assert block.timestamp <= self.donation_deadline, msg_donation_period_ended    
        self.donors[msg.sender] = msg.value


@external
def reveal():
    assert block.timestamp > self.donation_deadline, "it is still funding time"
    msg_funding_not_achieved = ("funding goal not achieved, call refund() "
            "to get your fund back")
    assert self.balance >= self.funding_goal, msg_funding_not_achieved
    #return True  
    #TODO discuss this function
    
@external
def refund():
    assert block.timestamp > self.donation_deadline, "it is still funding time"
    msg_funding_not_achieved = ("funding goal achieved, beneficiary will be "
            "able to calim the fund after achiving milestone")
    assert self.balance < self.funding_goal, "no fund to claim"
    assert self.donors[msg.sender] > 0, "no fund to claim"
    amount:uint256 = self.donors[msg.sender]
    self.donors[msg.sender] = 0
    send(msg.sender,amount)

@external
def claim_fund():
    token:address = Carbon_token
    assert block.timestamp >= self.donation_deadline, ("it is still funding time, you cannot claim fund until ")
    assert block.timestamp <= self.milestone_deadline, "Claim_fund time has passed"
    assert msg.sender == self.beneficiary, ("Only the beneficiary allowed to"
            "claim the fund")
    assert ERC20(token).balanceOf(self.beneficiary) >= self.milestone, ("You "
        "cannot")
    selfdestruct(self.beneficiary)

@external
def transfer_to_DAO():
    token:address = Carbon_token
    assert block.timestamp > self.milestone_deadline, ("It is still early to transfer "
                "the fund to the DAO")
    assert msg.sender == self.charity, "Only the charity entity is allowed"
    msg_not_yet_ = "Charity entity cannot tranfer to the DAO yet"
    assert ERC20(token).balanceOf(self.beneficiary) < self.milestone, msg_not_yet
    selfdestruct(DAO_treasury)
