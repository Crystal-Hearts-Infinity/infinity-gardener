#@version ^0.3.7

"""
1) Charity entities are allowed to deploy Smart Contract to raise fund based on needs from donators.
2) Beneficiary has to work hard to complete the milestone, for example, plant trees and earn Carb tokens 
to claim the fund from the Smart Contract.
"""

funding_goal:public(uint256)
participants:HashMap[address,uint256]
owner:public(address)
start_time:public(uint256)
deadline:public(uint256) 
beneficiary: address
milestone: public(uint256)
end_time:public(uint256)

@external
def __init__(owner: address,_funding_goal:uint256, _funding_time:uint256, _beneficiary:address,
          _milestone:uint256,_time:uint256):
    self.owner=msg.sender
    self.funding_goal=_funding_goal
    self.beneficiary=_beneficiary
    self.start_time=block.timestamp
    self.deadline=self.start_time+_funding_time
    self.end_time=self.deadline+_time
    self.milestone=_milestone

@external
def setup(_masterCopy: address, owner: address,_funding_goal:uint256, _funding_time:uint256,
    _beneficiary:address,_milestone:uint256,_time:uint256): #setup the contract 
    self.owner == ZERO_ADDRESS, "owner != zero address"
    self.owner=msg.sender
    self.funding_goal=_funding_goal
    self.beneficiary=_beneficiary
    self.start_time=block.timestamp
    self.deadline=self.start_time+_funding_time
    self.end_time=self.deadline+_time
    self.milestone=_milestone

@external
@payable
def fund():
    assert block.timestamp >= self.start_time
    assert block.timestamp <= self.deadline
    self.participants[msg.sender]=msg.value

@external
def reveal():
    assert block.timestamp > self.deadline,"it's still funding time"
    assert self.balance >= self.funding_goal, 
            "funding goal not achieved, call refund() to get your fund back"
    selfdestruct(self.beneficiary)

@external
def refund():
    assert block.timestamp > self.deadline,"it's still funding time"
    assert self.balance < self.funding_goal,"funding goal achieved, fund will be send to the beneficiary"
    assert self.participants[msg.sender]>0, "no fund to claim"
    amount:uint256 = self.participants[msg.sender]
    self.participants[msg.sender]=0
    send(msg.sender,amount)
