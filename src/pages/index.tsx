import { motion } from 'framer-motion'

export default function Home() {
  return (
    <motion.div
      className="min-h-screen flex flex-col items-center justify-center bg-primary text-white"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 1 }}
    >
      <h1 className="text-5xl font-bold mb-4">XShield</h1>
      <p className="text-xl mb-6 text-center max-w-xl">
        Yazılım, Siber Güvenlik, Ağ Teknolojileri, Sunucu ve Danışmanlık Hizmetleri
      </p>
      <div className="flex gap-4">
        <a href="/software" className="px-6 py-3 bg-accent rounded-lg hover:bg-blue-500 transition">
          Yazılım
        </a>
        <a href="/cybersecurity" className="px-6 py-3 bg-accent rounded-lg hover:bg-blue-500 transition">
          Siber Güvenlik
        </a>
      </div>
    </motion.div>
  )
}
