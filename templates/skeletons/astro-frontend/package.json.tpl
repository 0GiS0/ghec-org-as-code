{
  "name": "${replace(values.name, "-", "_")}",
  "type": "module",
  "version": "0.0.1",
  "scripts": {
    "dev": "astro dev",
    "start": "astro dev",
    "build": "astro check && astro build",
    "preview": "astro preview",
    "astro": "astro",
    "check": "astro check"
  },
  "dependencies": {
    "astro": "^5.13.2",
    "@astrojs/check": "^0.9.4",
    "typescript": "^5.0.0"
  },
  "devDependencies": {
    "@types/node": "^ 24.3.0"
  }
}