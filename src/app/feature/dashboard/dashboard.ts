import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { BackgroundImageService } from './background-image.service';

@Component({
  selector: 'creme-dashboard',
  standalone: true,
  imports: [CommonModule, HttpClientModule],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.scss',
  providers: [BackgroundImageService]
})
export class Dashboard implements OnInit {
  backgroundImageUrl = signal<string | null>(null);
  isLoading = signal<boolean>(true);

  constructor(private backgroundImageService: BackgroundImageService) {}

  ngOnInit() {
    this.loadBackgroundImage();
  }

  loadBackgroundImage() {
    this.isLoading.set(true);
    this.backgroundImageService.getBackgroundImage().subscribe({
      next: (response) => {
        if (response.imageUrl) {
          // Convert relative URL to absolute
          const fullUrl = response.imageUrl.startsWith('http') 
            ? response.imageUrl 
            : `http://localhost:3000${response.imageUrl}`;
          this.backgroundImageUrl.set(fullUrl);
        }
        this.isLoading.set(false);
      },
      error: (error) => {
        console.error('Error loading background image:', error);
        this.isLoading.set(false);
      }
    });
  }
}

