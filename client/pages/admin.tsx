import React, { useEffect, useState } from "react";
import { useRouter } from "next/router";
import { getContract } from "@/utils/getEther";

const Admin = (): JSX.Element => {
  const router = useRouter();
  useEffect(() => {
    async function authenticate() {
      try {
        const contract = await getContract();
        const admin = await contract.check_admin();
        console.log(admin);
      } catch (err: any) {
        alert(err.reason);
        router.push({ pathname: "/" });
      }
    }
    authenticate();
  }, [router]);
  return <></>;
};

export default Admin;
