from brownie import accounts, DPubToken, history 

address = "0x6b175474e89094c44da98b954eedeac495271d0f"

def test_deploy_token(): 
    """ 
    Test token's deployment. 
    """ 
    token = DPubToken.deploy(10**18, {"from": accounts[1]}) 
    # print(token)     
    assert token in DPubToken
