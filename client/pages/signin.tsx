import React from "react";
import { getProvider } from "@/utils/getEther";

const SignIn = (): JSX.Element => {
  const signIn = async () => {
    try {
      const provider = getProvider();
      if (!window.ethereum) {
        alert("you don't have wallet in you browser");
      } else {
        const accounts = await window.ethereum.request({
          method: "wallet_requestPermissions",
          params: [
            {
              eth_accounts: {},
            },
          ],
        });
        console.log(accounts);
      }
    } catch (err: any) {
      console.log(err.message);
    }
  };
  return (
    <>
      <button onClick={signIn}>Connect Wallet</button>
    </>
  );
};

export default SignIn;
