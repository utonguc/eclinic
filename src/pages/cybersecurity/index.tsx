import Navbar from '../../components/Navbar'
import Footer from '../../components/Footer'
import { motion } from 'framer-motion'

export default function CyberSecurity() {
  return (
    <div className="bg-primary min-h-screen flex flex-col text-white">
      <Navbar />
      <motion.main
        className="flex-1 flex flex-col items-center justify-center px-4"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 1 }}
      >
        <h1 className="text-4xl font-bold mb-4">Siber Güvenlik Hizmetlerimiz</h1>
        <p className="max-w-2xl text-center">
          XShield, kurumsal ağlarınızın güvenliğini sağlar, saldırılara karşı önlem alır ve siber tehditlere karşı sürekli izleme sunar.
        </p>
      </motion.main>
      <Footer />
    </div>
  )
}
