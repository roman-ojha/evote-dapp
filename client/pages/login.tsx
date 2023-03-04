import React, { useEffect, useRef } from "react";
import { getContract } from "@/utils/getEther";
import { useRouter } from "next/router";
import CSS from "csstype";

const containerStyle: CSS.Properties = {
  width: "100%",
  height: "100vh",
  display: "flex",
  justifyContent: "center",
  alignItems: "center",
};

const buttonStyle: CSS.Properties = {
  padding: "10px",
  borderRadius: "5px",
  backgroundColor: "lightgreen",
  borderWidth: "0px",
  color: "black",
  cursor: "pointer",
};

const SignIn = (): JSX.Element => {
  const router = useRouter();
  let checkUser: NodeJS.Timer;
  const divElm: React.MutableRefObject<null | HTMLDivElement> = useRef(null);
  const processing = () => {
    const pElm = document.createElement("p");
    pElm.innerHTML = "Processing... please wait for a while";
    pElm.setAttribute("style", "font-size:20px");
    divElm.current?.replaceChildren(pElm);
  };
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
          try {
            if (res) {
              processing();
              checkUser = setInterval(async () => {
                const user = await contract.get_user();
                if (user) {
                  clearInterval(checkUser);
                  router.push({ pathname: "/" });
                }
              }, 1000);
            }
          } catch (err) {
            processing();
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
      <div id="container" ref={divElm} style={containerStyle}>
        <button onClick={signIn} style={buttonStyle}>
          Connect Wallet
        </button>
      </div>
    </>
  );
};

export default SignIn;
