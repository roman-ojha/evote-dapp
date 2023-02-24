import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import styles from "@/styles/Home.module.css";
import getEther from "@/utils/getEther";

export default function Home() {
  async function getProvider() {
    const provider: ethers.BrowserProvider = await getEther();
    await provider.send("eth_requestAccounts", []);
    const signer = await provider.getSigner();
  }
  useEffect(() => {
    getProvider();
  }, []);
  return (
    <>
      <button>Connect Wallet</button>
      {/* <h3>Waller address is: {walletAddress}</h3> */}
    </>
  );
}
