import React from "react";
import getContract from "@/utils/getContract";

export default function Home() {
  async function getProvider() {
    const contract = await getContract();
    console.log(await contract.get_user());
  }

  return (
    <>
      <button onClick={getProvider}>Connect Wallet</button>
    </>
  );
}
