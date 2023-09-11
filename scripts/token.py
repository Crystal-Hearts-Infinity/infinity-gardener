#!/usr/bin/python3

from brownie import Token, accounts


def main():
    account = accounts.load('deployment_account')
    return Token.deploy("Carbon Token", "CBT", 18, 1e21, {'from': account})
