import React, { useEffect,useState } from 'react'
import { Text} from '@chakra-ui/react'
import { AkapzABI as abi } from "../abi/AkapzABI";
import { ethers } from "ethers";

interface Props {
    addressContract: string,
    currentAccount: string | undefined
}

export default function ReadERC20(props:Props){
  const addressContract = props.addressContract
  const currentAccount = props.currentAccount
  const [totalSupply,setTotalSupply]=useState<string>()
  const [symbol,setSymbol]= useState<string>("")
  const [balance, SetBalance] =useState<number|undefined>(undefined)


  useEffect( () => {
    if(!window.ethereum) return

    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const erc20 = new ethers.Contract(addressContract, abi, provider);
    erc20.symbol().then((result:string)=>{
        setSymbol(result)
    }).catch('error', console.error)

    erc20.totalSupply().then((result:string)=>{
        setTotalSupply(ethers.utils.formatEther(result))
    }).catch('error', console.error);
    //called only once
  },[])  

  useEffect(()=>{
    if(!window.ethereum) return
    if(!currentAccount) return

    queryTokenBalance(window)
  },[currentAccount])

  async function queryTokenBalance(window:any){
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const erc20 = new ethers.Contract(addressContract, abi, provider);

    erc20.balanceOf(currentAccount)
    .then((result:string)=>{
        SetBalance(Number(ethers.utils.formatEther(result)))
    })
    .catch('error', console.error)
  }  



return (
    <div>
        <Text >Contract: {addressContract}</Text>
        <Text>Akapz DAO Token totalSupply: {totalSupply} {symbol}</Text>
        <Text my={4}>Akapz DAO Token in current account: {balance}</Text>
    </div>
  )
}
