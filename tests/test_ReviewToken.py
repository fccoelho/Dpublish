import secrets 
from brownie import accounts, ReviewToken 

address = "0x" + secrets.token_hex(20) 

def test_ReviewToken(): 
    """ 
    Test ReviewToken's deployment. 
    """ 
    tk = ReviewToken.deploy({"from": address}) 

    assert tk in ReviewToken 
