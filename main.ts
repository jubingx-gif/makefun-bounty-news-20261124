import { copyFileSync, mkdirSync, existsSync } from 'fs';
import { join } from 'path';

/**
 * make.fun Bounty Submission Script
 * Task: Sum up 24 November's world news in one image
 * Description: Copies the pre-generated image to the required output path.
 */

const SOURCE_IMAGE = join(process.cwd(), 'entry.png');
const OUTPUT_DIR = '/output';
const OUTPUT_FILE = join(OUTPUT_DIR, 'entry.png');

try {
  // Ensure output directory exists (though the sandbox usually provides it)
  if (!existsSync(OUTPUT_DIR)) {
    mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  // Copy the image to the destination
  copyFileSync(SOURCE_IMAGE, OUTPUT_FILE);
  console.log(`Successfully copied ${SOURCE_IMAGE} to ${OUTPUT_FILE}`);
} catch (error) {
  console.error('Failed to copy image:', error);
  process.exit(1);
}
