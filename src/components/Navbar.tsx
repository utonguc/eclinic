import Link from 'next/link'

export default function Navbar() {
  return (
    <nav className="bg-secondary text-white px-8 py-4 flex justify-between items-center">
      <div className="text-2xl font-bold">XShield</div>
      <ul className="flex gap-6">
        <li><Link href="/">Ana Sayfa</Link></li>
        <li><Link href="/software">Yazılım</Link></li>
        <li><Link href="/cybersecurity">Siber Güvenlik</Link></li>
        <li><Link href="/network">Ağ Teknolojileri</Link></li>
        <li><Link href="/servers">Sunucu</Link></li>
        <li><Link href="/consulting">Danışmanlık</Link></li>
        <li><Link href="/blog">Blog</Link></li>
      </ul>
    </nav>
  )
}
