import React from "react";
import { getProvider } from "@/utils/getEther";
import { getContract } from "@/utils/getEther";
import { useRouter } from "next/router";

const SignIn = (): JSX.Element => {
  const router = useRouter();
  const signIn = async () => {
    try {
      if (!window.ethereum) {
        alert("you don't have wallet in you browser");
      } else {
        // const accounts = await window.ethereum.request({
        //   method: "wallet_requestPermissions",
        //   params: [
        //     {
        //       eth_accounts: {},
        //     },
        //   ],
        // });
        const contract = await getContract();
        const res = await contract.login();
        if (res) {
          router.push({ pathname: "/" });
        }
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
