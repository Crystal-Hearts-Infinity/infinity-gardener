# @version ^0.3.7

"""
This is a Master Smart Contract to deploy other Smart Contract for Charity Entites
"""

interface ContractToDeploy:
    def setup(owner: address): nonpayable

event DeployLog:
    masterCopy: indexed(address)  # sample smart contracts have been deployed
    # owner of the Smart Contracts, it belongs to the corresponding Charity Entity
    owner: indexed(address)
    funding_goal: int128 #fund raising goal defined by the Owner 
    funding_time: uint256 #fund raising time defined by the Owner 
    beneficiary: indexed(address) #beneficiary defined by the Owner
    # milestones for the beneficiaty to achieve. for example, a number of tokens representing the
    # contribution 
    milestone: int128 
    time: uint256 #time for beneficiary to achieve the goal

@external
"""
@param _masterCopy is an address of a sample smart contract been deployed
@notice please refer to https://vyper-by-example.org/create-new-contract/
"""
def deploy(_masterCopy: address, owner: address,_funding_goal:uint256, _funding_time:uint256, 
        _beneficiary:address,_milestone:uint256,_time:uint256):
    addr: address = create_forwarder_to(_masterCopy)
    ContractToDeploy(addr).setup(owner, _funding_goal,_funding_time, _beneficiary,_milestone,_time)
    log DeployLog(addr,owner, _funding_goal,_funding_time, _beneficiary,_milestone,_time)

@external
def deployTest(_masterCopy: address, owner: address,_funding_goal:uint256, _funding_time:uint256,
        _beneficiary:address,_milestone:uint256,_time:uint256):
    addr: address = create_forwarder_to(_masterCopy)
    ContractToDeploy(addr).setup(self)
    log DeployLog(addr,owner, _funding_goal,_funding_time, _beneficiary,_milestone,_time)
