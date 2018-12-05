import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'quiz-ui';
  constructor(private http: HttpClient) {

  }

  ngOnInit() {
    this.http.get<any>('http://localhost:4000/healtcheck')
      .subscribe(response => console.log(response));
  }

}
