import { Component, OnInit, ViewEncapsulation } from "@angular/core";
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { Router } from "@angular/router";
import { User } from "../models/user";
import { AuthService } from "../services/auth.service";

@Component({
  selector: "app-login",
  templateUrl: "./login.component.html",
  styleUrls: ["./login.component.scss"],
  encapsulation: ViewEncapsulation.None
})
export class LoginComponent implements OnInit {
  loginForm: FormGroup;
  user: User;

  constructor(
    private formBuilder: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit() {
    this.loginForm = this.formBuilder.group({
      username: ["", Validators.required],
      password: ["", Validators.required],
    });
  }

  login() {
    this.user = new User({
      username: this.loginForm.value.username,
      password: this.loginForm.value.password,
    });

    this.authService.login(this.user).subscribe((user) => {
      switch(user.role) {
        case 'SHOPPER':
          this.router.navigateByUrl('/products');
          break;
        case 'SELLER':
        default:
          this.router.navigateByUrl('/home');
          break;
      }});
  }
}
