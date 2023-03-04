import React, { useEffect } from "react";
import { getProvider } from "@/utils/getEther";
import { getContract } from "@/utils/getEther";
import { useRouter } from "next/router";

const SignIn = (): JSX.Element => {
  const router = useRouter();
  let checkUser: NodeJS.Timer;
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
        contract.login().then((res) => {
          if (res) {
            checkUser = setInterval(async () => {
              try {
                const user = await contract.get_user();
                if (user) {
                  clearInterval(checkUser);
                  router.push({ pathname: "/" });
                }
              } catch (err) {}
            }, 1000);
          }
        });
      }
    } catch (err: any) {
      console.log(err.message);
    }
  };
  useEffect(() => {
    return () => {
      clearInterval(checkUser);
    };
  }, []);
  return (
    <>
      <div id="container">
        <button onClick={signIn}>Connect Wallet</button>
      </div>
    </>
  );
};

export default SignIn;
