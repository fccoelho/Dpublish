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
    except VirtualMachineError as err: 
        strerr = str(err)[:str(err).index("\n")]
        assert strerr == "revert: Manuscript already submitted! Wait for a review." 
    
    # Unsubmit manuscript 
    dpublish.unsubmit_manuscript("a", {"from": accounts[1]}) 
    
    # The value is retrieved on unsubmission 
    assert accounts[1].balance() == curr_balance 

    # Unsubmit non existing manuscript 
    try: 
        dpublish.unsubmit_manuscript("a", {"from": accounts[1]}) 
    except VirtualMachineError as err: 
        strerr = str(err)[:str(err).index("\n")] 
        assert strerr == "revert: Thou must burn an existing manuscript!" 

    # Trying to unsubmit a manuscript from other author 
    dpublish.submit_manuscript("a", {"from": accounts[1], "value": value}) 

    try: 
        dpublish.unsubmit_manuscript("a", {"from": accounts[2], "value": value}) 
    except VirtualMachineError as err: 
        strerr = str(err)[:str(err).index("\n")] 
        assert strerr == "revert: You must be the author!" 


def test_register_reviewer(): 
    dpublish = DPublish.deploy({"from": address}) 
    
    curr_balance = accounts[1].balance() 

    # Register reviewer for non existing manuscript 
    try: 
        dpublish.registerReviewer("a", {"from": accounts[1]}) 
    except VirtualMachineError as err:    
        strerr = str(err)[:str(err).index("\n")] 
        assert strerr == "revert: The paper doesn't exist!" 

    # Submit a manuscript 
    dpublish.submit_manuscript("a", {"from": accounts[1], 
        "value": 9999}) 
    
    # Register a reviewer for the manuscript 
    curr_balance = accounts[2].balance() 

    value = 999 
    dpublish.registerReviewer("a", {"from": accounts[2], "value": value}) 
    
    balance = accounts[2].balance() 
    assert curr_balance - balance == value 
    
    # Check fee for reviewing 
    try: 
        dpublish.registerReviewer("a", {"from": accounts[1], "value": 1}) 
        # Notice that it is possible that the author register as a reviewer 
        # for her own article; however, she should pay to do so. 
    except VirtualMachineError as err: 
        strerr = str(err)[:str(err).index("\n")] 
        assert strerr == "revert: There is a fee for reviewing!" 

 

