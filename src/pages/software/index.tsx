import Navbar from '../../components/Navbar'
import Footer from '../../components/Footer'
import { motion } from 'framer-motion'

export default function Software() {
  return (
    <div className="bg-primary min-h-screen flex flex-col text-white">
      <Navbar />
      <motion.main
        className="flex-1 flex flex-col items-center justify-center px-4"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 1 }}
      >
        <h1 className="text-4xl font-bold mb-4">Yazılım Hizmetlerimiz</h1>
        <p className="max-w-2xl text-center">
          XShield olarak web, mobil ve kurumsal yazılım çözümleri sunuyoruz. Modern ve güvenli altyapılarla iş süreçlerinizi optimize ediyoruz.
        </p>
      </motion.main>
      <Footer />
    </div>
  )
}
