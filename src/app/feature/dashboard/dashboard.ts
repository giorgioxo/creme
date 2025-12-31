import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ContentService } from './content.service';

@Component({
  selector: 'creme-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.scss'
})
export class Dashboard implements OnInit {
  backgroundImageUrl = '/assets/images/cin.jpg';
  comingSoonText = signal<string>('');
  isLoading = signal<boolean>(true);

  constructor(private contentService: ContentService) {}

  ngOnInit() {
    this.loadComingSoonText();
  }

  loadComingSoonText() {
    this.isLoading.set(true);
    this.contentService.getComingSoonText().subscribe({
      next: (response) => {
        this.comingSoonText.set(response.text);
        this.isLoading.set(false);
      },
      error: (error) => {
        console.error('Error loading coming soon text:', error);
        // Fallback text if API fails
        this.comingSoonText.set('Crème - Coming Soon');
        this.isLoading.set(false);
      }
    });
  }

  // Split text into parts: "CREME" and "COMING SOON"
  getTextParts(text: string): { creme: string; comingSoon: string } {
    const parts = text.split(' - ');
    return {
      creme: parts[0] || 'CRÈME',
      comingSoon: parts[1] || 'COMING SOON'
    };
  }
}
