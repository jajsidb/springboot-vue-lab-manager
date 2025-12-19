<template>
  <canvas ref="canvas" class="fluid-background"></canvas>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const canvas = ref<HTMLCanvasElement | null>(null)
let ctx: CanvasRenderingContext2D | null = null
let animationId: number
let width: number
let height: number

interface Blob {
  x: number
  y: number
  vx: number
  vy: number
  radius: number
  color: string
}

const blobs: Blob[] = []
const blobCount = 6
const colors = [
  '#FF6B6B', // Red
  '#4ECDC4', // Teal
  '#45B7D1', // Blue
  '#96CEB4', // Green
  '#FFEEAD', // Yellow
  '#D4A5A5'  // Pink
]

const initBlobs = () => {
  blobs.length = 0
  for (let i = 0; i < blobCount; i++) {
    blobs.push({
      x: Math.random() * width,
      y: Math.random() * height,
      vx: (Math.random() - 0.5) * 2,
      vy: (Math.random() - 0.5) * 2,
      radius: Math.min(width, height) * (0.3 + Math.random() * 0.2),
      color: colors[i % colors.length]!
    })
  }
}

const mouse = { x: -1000, y: -1000 }
const ripples: { x: number; y: number; radius: number; alpha: number }[] = []

const handleMouseMove = (e: MouseEvent) => {
  mouse.x = e.clientX
  mouse.y = e.clientY
  
  // Create ripple on movement
  // Increased frequency and intensity
  if (Math.random() > 0.5) { 
    ripples.push({
      x: mouse.x,
      y: mouse.y,
      radius: 5,
      alpha: 0.8 // Higher initial alpha
    })
  }
}

const draw = () => {
  if (!ctx || !canvas.value) return
  
  // Clear canvas
  ctx.clearRect(0, 0, width, height)
  
  // 1. Draw Blobs (Background Layer)
  blobs.forEach(blob => {
    // Basic movement
    blob.x += blob.vx
    blob.y += blob.vy
    
    // Mouse interaction: Repel blobs slightly
    const dx = blob.x - mouse.x
    const dy = blob.y - mouse.y
    const distance = Math.sqrt(dx * dx + dy * dy)
    const maxDist = 400 // Increased interaction range
    
    if (distance < maxDist) {
      const force = (maxDist - distance) / maxDist
      blob.x += dx / distance * force * 3 // Stronger repulsion
      blob.y += dy / distance * force * 3
    }
    
    // Bounce off walls
    if (blob.x < -blob.radius) blob.vx = Math.abs(blob.vx)
    if (blob.x > width + blob.radius) blob.vx = -Math.abs(blob.vx)
    if (blob.y < -blob.radius) blob.vy = Math.abs(blob.vy)
    if (blob.y > height + blob.radius) blob.vy = -Math.abs(blob.vy)
    
    // Draw blob
    ctx!.beginPath()
    const gradient = ctx!.createRadialGradient(blob.x, blob.y, 0, blob.x, blob.y, blob.radius)
    gradient.addColorStop(0, blob.color)
    gradient.addColorStop(1, 'rgba(255, 255, 255, 0)')
    
    ctx!.fillStyle = gradient
    ctx!.globalCompositeOperation = 'screen'
    ctx!.arc(blob.x, blob.y, blob.radius, 0, Math.PI * 2)
    ctx!.fill()
  })
  
  // 2. Draw Ripples (Foreground Layer)
  ctx.globalCompositeOperation = 'source-over'
  for (let i = ripples.length - 1; i >= 0; i--) {
    const ripple = ripples[i]!
    
    ripple.radius += 3 // Faster expansion
    ripple.alpha -= 0.015 // Faster fade
    
    if (ripple.alpha <= 0) {
      ripples.splice(i, 1)
      continue
    }
    
    ctx.beginPath()
    ctx.arc(ripple.x, ripple.y, ripple.radius, 0, Math.PI * 2)
    ctx.strokeStyle = `rgba(255, 255, 255, ${ripple.alpha})`
    ctx.lineWidth = 3 // Thicker lines
    ctx.stroke()
  }
  
  animationId = requestAnimationFrame(draw)
}

const handleResize = () => {
  if (!canvas.value) return
  width = window.innerWidth
  height = window.innerHeight
  canvas.value.width = width
  canvas.value.height = height
  initBlobs()
}

onMounted(() => {
  if (canvas.value) {
    ctx = canvas.value.getContext('2d')
    handleResize()
    window.addEventListener('resize', handleResize)
    window.addEventListener('mousemove', handleMouseMove)
    draw()
  }
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  window.removeEventListener('mousemove', handleMouseMove)
  cancelAnimationFrame(animationId)

})
</script>

<style scoped>
.fluid-background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -1;
  background: #1a1a2e; /* Dark background base */
  filter: blur(80px); /* Heavy blur for fluid effect */
  transform: scale(1.2); /* Avoid edge blur issues */
}
</style>
