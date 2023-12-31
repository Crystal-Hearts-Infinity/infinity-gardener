# @version ^0.3.7

"""
This is a Master Smart Contract to deploy other Smart Contracts for Charity Entites
"""

owner:public(address)

interface ContractToDeploy:
    def setup(_masterCopy: address, charity: address,_funding_goal:uint256, 
                _funding_time:uint256, _beneficiary:address, 
                _milestone:uint256, _time:uint256): nonpayable

event DeployLog:
    masterCopy: indexed(address)  # a Smart Contract address that Charity Entites choose to deplpy
    # owner of the Smart Contract, it belongs to the corresponding Charity Entity
    charity: indexed(address)
    funding_goal: uint256 # fund raising goal defined by the charity 
    funding_time: uint256 # fund raising time defined by the charity 
    beneficiary: indexed(address) # beneficiary defined by the charity
    # milestones for the beneficiaty to achieve. for example, a number of tokens 
    # representing the contribution 
    milestone: uint256 
    time: uint256  # time for beneficiary to achieve the goal


@external
def __init__():
    self.owner = msg.sender

@external
def deploy_new_contract(_masterCopy: address, charity: address,_funding_goal:uint256, _funding_time:uint256, 
    _beneficiary:address,_milestone:uint256,_time:uint256):
    assert self.owner == msg.sender
    addr: address = create_forwarder_to(_masterCopy) 
    ContractToDeploy(addr).setup(_masterCopy, charity, _funding_goal,_funding_time,
                _beneficiary,_milestone,_time)
    log DeployLog(_masterCopy, charity, _funding_goal, _funding_time, 
                _beneficiary, _milestone, _time)