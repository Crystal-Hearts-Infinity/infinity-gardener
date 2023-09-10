# @version ^0.3.7

"""
This is a Master Smart Contract to deploy other Smart Contract for Charity Entites
"""

interface ContractToDeploy:
    def setup(owner: address): nonpayable


event DeployLog:
    masterCopy:
    addr: indexed(address)
    funding_goal:
    funding_time:
    beneficiary:


@external
"""
@param _masterCopy is an address of a sample smart contract been deployed
"""
def deploy(_masterCopy: address, owner: address,_funding_goal:uint256, _beneficiary:address,_funding_time:uint256):
    addr: address = create_forwarder_to(_masterCopy)
    ContractToDeploy(addr).setup(owner, _funding_goal, _beneficiary,_funding_time)
    log DeployLog(addr)


@external
def deployTest(_masterCopy: address):
    addr: address = create_forwarder_to(_masterCopy)
    ContractToDeploy(addr).setup(self)
    log DeployLog(addr)


