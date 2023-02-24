import React from "react";
import {} from "ethers";
import { getContract } from "@/utils/getEther";

export default function Home() {
  async function getProvider() {
    try {
      const contract = await getContract();
      console.log(await contract.get_user());
    } catch (err: any) {
      alert(err.reason);
    }
  }

  return (
    <>
      <button onClick={getProvider}>Connect Wallet</button>
    </>
  );
}
