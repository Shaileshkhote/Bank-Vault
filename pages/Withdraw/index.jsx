
import Header from '../../components/Header'
import Footer from '../../components/Footer'
import { useEffect, useState} from 'react'
import Withdraw from '../../components/Withdraw'


const home = () => {

  const [account, setAccount] = useState()

  useEffect(() => {

    if (window.ethereum) {
      // res[0] for fetching a first wallet
      window.ethereum
        .request({ method: 'eth_requestAccounts' })
        .then((res) => setAccount(res[0]))
    } else {
      alert('install metamask extension!!')
    }


  })
  
  return (
    <div className="bg-gray-700">
  
      <Header />
      <Withdraw/>
      <Footer/>
  </div>
  )
}

export default home
