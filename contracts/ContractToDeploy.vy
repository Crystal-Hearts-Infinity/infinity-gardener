#@version 0.3.7

"""
1) raise fund
2) beneficiary has to work hard to complete the goal, for example, plant trees 
3) the smart contract will release the funds based on the Carb Tokens in beneciciary's wallet balance, like 50% to 100% 
"""


funding_goal:public(uint256)
participants:HashMap[address,uint256]
owner:public(address)
start_time:public(uint256)
deadline:public(uint256) 
beneficiary: address

@external
def __init__(_funding_goal:uint256,_beneficiary:address,time:uint256):
	self.owner=msg.sender
	self.funding_goal=_funding_goal
	self.beneficiary=_beneficiary
	self.start_time=block.timestamp
	self.deadline=self.start_time+time


@external
def setup():
	self.owner == ZERO_ADDRESS, "owner != zero address"
	self.owner = owner

@external
@payable
def fund():
	assert block.timestamp >= self.start_time
	assert block.timestamp <= self.deadline
	self.participants[msg.sender]=msg.value


@external
def reveal():
	assert block.timestamp > self.deadline,"it's still funding time"
	assert self.balance >= self.funding_goal,"funding goal not achieved, call refund() to get your fund back"
	selfdestruct(self.beneficiary)
	

@external
def refund():
	assert block.timestamp > self.deadline,"it's still funding time"
	assert self.balance < self.funding_goal,"funding goal achieved, fund will be send to the beneficiary"
	assert self.participants[msg.sender]>0, "no fund to claim"
	amount:uint256 = self.participants[msg.sender]
	self.participants[msg.sender]=0
	send(msg.sender,amount)


