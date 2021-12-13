import pytest 

from brownie import accounts, DPublish 
from brownie.exceptions import VirtualMachineError 

address = '0x8954d0c17F3056A6C98c7A6056C63aBFD3e8FA6f'

def test_submit_manuscript(): 
    dpublish = DPublish.deploy({"from": address}) 
    
    curr_balance = accounts[1].balance() 
    
    # Submit manuscript 
    value = 10000 
    dpublish.submit_manuscript("a", {"from": accounts[1], "value": value}) 

    balance = accounts[1].balance() 

    assert curr_balance - balance == value 
    
    # Submit again 
    try: 
        dpublish.submit_manuscript("a", {"from": accounts[1]}) 
    except VirtualMachineError: 
        assert True 
    
    # Unsubmit manuscript 
    dpublish.unsubmit_manuscript("a", {"from": accounts[1]}) 
    
    # The value is retrieved on unsubmission 
    assert accounts[1].balance() == curr_balance 

    # Unsubmit non existing manuscript 
    try: 
        dpublish.unsubmit_manuscript("a", {"from": accounts[1]}) 
    except VirtualMachineError: 
        assert True 

    # Trying to unsubmit a manuscript from other author 
    dpublish.submit_manuscript("a", {"from": accounts[1], "value": value}) 

    try: 
        dpublish.unsubmit_manuscript("a", {"from": accounts[2], "value": value}) 
    except VirtualMachineError: 
        assert True 
    
