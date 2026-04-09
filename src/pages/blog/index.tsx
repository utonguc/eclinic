import Navbar from '../../components/Navbar'
import Footer from '../../components/Footer'
import { motion } from 'framer-motion'
import Link from 'next/link'

export default function Blog() {
  const posts = [
    { title: 'Siber Güvenlik Trendleri 2026', slug: 'siber-guvenlik-trendleri-2026' },
    { title: 'Yeni Nesil Ağ Teknolojileri', slug: 'yeni-nesil-ag-teknolojileri' },
  ]

  return (
    <div className="bg-primary min-h-screen flex flex-col text-white">
      <Navbar />
      <motion.main className="flex-1 px-4 py-8" initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 1 }}>
        <h1 className="text-4xl font-bold mb-6">Blog</h1>
        <ul className="space-y-4">
          {posts.map((post) => (
            <li key={post.slug}>
              <Link href={`/blog/${post.slug}`} className="text-accent hover:underline">
                {post.title}
              </Link>
            </li>
          ))}
        </ul>
      </motion.main>
      <Footer />
    </div>
  )
}
