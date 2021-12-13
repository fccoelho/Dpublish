import pytest 

from brownie import accounts, DPublish, ReviewToken 
from brownie.exceptions import VirtualMachineError 

import numpy as np 

address = '0x8954d0c17F3056A6C98c7A6056C63aBFD3e8FA6f'
assertion_msg = "An exception should be raised in this case!" 

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
        assert False, assertion_msg 
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
        assert False, assertion_msg 
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
        assert False, assertion_msg 
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
        assert False, assertion_msg 
    except VirtualMachineError as err: 
        strerr = str(err)[:str(err).index("\n")] 
        assert strerr == "revert: There is a fee for reviewing!" 

def test_review(): 
    dpublish = DPublish.deploy({"from": address}) 

    # Submit manuscript 
    dpublish.submit_manuscript("a", {"from": accounts[1], 
        "value": 9999}) 

    # Register reviewer 
    dpublish.registerReviewer("a", {"from": accounts[2], "value": 999}) 
   
    # Expected behaviour of review 
    dpublish.review("a", 5, {"from": accounts[2]}) 
    
    # Try to review without being a reviewer 
    try: 
        dpublish.review("a", 5, {"from": accounts[3]}) 
        assert False, assertion_msg 
    except VirtualMachineError as err: 
        strerr = str(err)[:str(err).index("\n")] 
        assert strerr == "revert: You must register to review a paper!" 
    
    # Inappropriate scale for review 
    try: 
        dpublish.review("a", 999, {"from": accounts[2]}) 
        assert False, assertion_msg 
    except VirtualMachineError as err: 
        strerr = str(err)[:str(err).index("\n")] 
        assert strerr == "revert: The review must be a number between 1 and 5, reviewer!" 

def test_rateReview(): 
    dpublish = DPublish.deploy({"from": address}) 

    # Submit manuscript 
    dpublish.submit_manuscript("a", {"from": accounts[1], 
        "value": 9999}) 

    # Register reviewers 
    reviewers = 5 
    for i in range(reviewers): 
        dpublish.registerReviewer("a", 
                {"from": accounts[i], "value": 999}) 

    # Review manuscript 
    for i in range(reviewers): 
        dpublish.review("a", np.random.randint(1, 6),  
                {"from": accounts[i]}) 

    # Rate review 
    reviews = dpublish.getRatingsList().return_value 
    
    # Try to rate your own review 
    try: 
        dpublish.rateReview(reviews[1], 5, {"from": accounts[1]}) 
        assert False, assertion_msg   
    except VirtualMachineError as err: 
        strerr = str(err)[:str(err).index("\n")] 
        assert strerr == "revert: You shouldn't rate your own reviews!", strerr 

    # Verify stake threshold for rating a review 

    # Initially, we modify accounts[9]' balance 
    dpublish.submit_manuscript("ax", 
            {"from": accounts[9], "value": accounts[9].balance()}) 
    
    # Then, we check the rating process   
    try: 
        dpublish.rateReview(reviews[1], 5, {"from": accounts[-1]}) 
        assert False, assertion_msg 
    except VirtualMachineError as err: 
        strerr = str(err)[:str(err).index("\n")] 
        assert strerr == "revert: There is a (stake) threshold for rating reviews!", strerr 

    # Rate a review that doesn't exist 
    try: 
        dpublish.rateReview(address, 5, {"from": accounts[3]}) 
        assert False, assertion_msg 
    except VirtualMachineError as err: 
        strerr = str(err)[:str(err).index("\n")] 
        assert strerr == "revert: Review should exist!", strerr 

    # assert reviews[1] == 1, reviews

class TestReleaseManuscript(): 
    # Test different scenarios for the 
    # release of the manuscript; 
    # explicitly, it will check whether the document 
    # has (1) an appropriate set of ratings, (2) a 
    # adequate set of reviewers and (3) a disposition 
    # to send tokens to the reviewers. 

def test_releaseManuscript(): 
    dpublish = DPublish.deploy({"from": address}) 

    # Submit 
    dpublish.submit_manuscript("a", {"from": accounts[1], 
        "value": 9999}) 
    
    # Register reviewers 
    reviewers = 5 
    values = [111 * (i + 1) for i in range(reviewers)] 
    for i in range(reviewers): 
        dpublish.registerReviewer("a", {"from": accounts[i], 
            "value": values[i]}) 
    
    # Review manuscripts 
    rates = [5 for _ in range(reviewers)] 
    
    rates[1] = 3 

    for i in range(reviewers): 
        dpublish.review("a", rates[i], 
                {"from": accounts[i]}) 


    # Rate reviews 
    reviews = dpublish.getRatingsList().return_value 
    
    curr_balance = accounts[2].balance() 

    dpublish.releaseManuscript("a") 
    
    assert accounts[2].balance() > curr_balance, accounts[2].balance() 





