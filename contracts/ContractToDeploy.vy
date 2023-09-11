#@version ^0.3.7

"""
1) Charity entities are allowed to deploy Smart Contract to raise fund based on needs from donators.
2) Beneficiary has to work hard to complete the milestone, for example, plant trees and earn Carb tokens 
to claim the fund from the Smart Contract.
"""

from vyper.interfaces import ERC20

funding_goal:public(uint256)
participants:HashMap[address,uint256]
owner:public(address)
start_time:public(uint256)
deadline:public(uint256) 
beneficiary: address
milestone: public(uint256)
end_time:public(uint256)
DAO_treasury: constant(address) = 0x7C074007b72c398C488526753739efFD092586e7
Carbon_token: constant(address) = 0x62997d381a5EF9fAC9ba2b22c3f10b45053DaB12


def __init__(owner: address,_funding_goal:uint256, _funding_time:uint256, 
	    _beneficiary:address,_milestone:uint256,_time:uint256):
	self.owner=msg.sender
	self.funding_goal=_funding_goal
	self.beneficiary=_beneficiary
	self.start_time=block.timestamp
	self.deadline=self.start_time+_funding_time
	self.end_time=self.deadline+_time
	self.milestone=_milestone
#	self.DAO_treasury = '0x7C074007b72c398C488526753739efFD092586e7'
#	self.Carbon_token = '0x62997d381a5EF9fAC9ba2b22c3f10b45053DaB12'

@external
def setup(_masterCopy: address, owner: address,_funding_goal:uint256, _funding_time:uint256, 
    _beneficiary:address,_milestone:uint256,_time:uint256): #setup the contract 
	self.owner=msg.sender
	self.funding_goal=_funding_goal
	self.beneficiary=_beneficiary
	self.start_time=block.timestamp
	self.deadline=self.start_time+_funding_time
	self.end_time=self.deadline+_time
	self.milestone=_milestone

@external
@payable
def donate():
	assert block.timestamp >= self.start_time, "donation not start yet"
	assert block.timestamp <= self.deadline,"donation period is end, thanks for your interest"
	self.participants[msg.sender]=msg.value


@external
def reveal():
	assert block.timestamp > self.deadline,"it's still funding time"
	assert self.balance >= self.funding_goal,"funding goal not achieved, call refund() to get your fund back"
	#return True  # if the donation collected before deadline, the fund will be send to
	
@external
def refund():
	assert block.timestamp > self.deadline,"it's still funding time"
	assert self.balance < self.funding_goal,"funding goal achieved, beneficiary will be able to calim the fund after achiving milestone"
	assert self.participants[msg.sender]>0, "no fund to claim"
	amount:uint256 = self.participants[msg.sender]
	self.participants[msg.sender]=0
	send(msg.sender,amount)


@external
def claim_fund():
    token:address = Carbon_token
    assert block.timestamp >= self.deadline,"it's still funding time, you can't claim fund until "
    assert block.timestamp <= self.end_time, "Claim_fund time has passed"
    assert msg.sender == self.beneficiary, "Only the beneficiary allowed to calim the fund"
    assert ERC20(token).balanceOf(self.beneficiary) >= self.milestone, " You can't "
    selfdestruct(self.beneficiary)


@external
def transfer_to_DAO():
	token:address = Carbon_token
	assert block.timestamp > self.end_time, "It's still early to transfer the fund to DAO"
	assert msg.sender == self.owner, "Only the charity entity allowed"
	assert ERC20(token).balanceOf(self.beneficiary) < self.milestone, " Charity entity can't tranfer to DAO yet"
	selfdestruct(DAO_treasury)

