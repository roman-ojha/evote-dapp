import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import styles from "@/styles/Home.module.css";
import getEther from "@/utils/getEther";
import EVote from "@/artifacts/contracts/EVote.sol/EVote.json";

export default function Home() {
  async function getProvider() {
    const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
    // const provider: ethers.providers.Web3Provider =
    //   new ethers.providers.Web3Provider(window.ethereum);
    const provider = new ethers.JsonRpcProvider("http://localhost:8545/");
    // await provider.send("eth_requestAccounts", []);
    // const signer = provider.getSigner();
    // console.log(await signer.getAddress());
    const contract = new ethers.Contract(contractAddress, EVote.abi, provider);
    // const signer = contract.connect(provider.getSigner());
    console.log(await contract.test("Hello"));
    // console.log(await signer.getAddress());
  }

  useEffect(() => {
    // getProvider();
  }, []);
  return (
    <>
      <button onClick={getProvider}>Connect Wallet</button>
      {/* <h3>Waller address is: {walletAddress}</h3> */}
    </>
  );
}
