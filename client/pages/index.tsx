import React, { useEffect, useState } from "react";
import { getContract } from "@/utils/getEther";
import { useRouter } from "next/router";

interface User {
  address: string;
  role: "admin" | "user" | null;
}

export default function Home() {
  const [user, setUser] = useState<User>({
    address: "",
    role: null,
  });

  const router = useRouter();
  useEffect(() => {
    async function authenticate() {
      try {
        const contract = await getContract();
        const user = await contract.get_user();
        setUser({
          address: user[0],
          role: user[1],
        });
      } catch (err: any) {
        // alert(err.reason);
        router.push({ pathname: "/login" });
      }
    }
    authenticate();
  }, [router]);

  return (
    <>
      <h1>Welcome {user.address}</h1>
    </>
  );
}
