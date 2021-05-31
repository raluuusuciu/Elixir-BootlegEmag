import { Component, OnInit, ViewEncapsulation } from "@angular/core";
import {
  FormBuilder,
  FormGroup,
  ValidationErrors,
  Validators,
} from "@angular/forms";
import { Router } from "@angular/router";
import { Role, User } from "../models/user";
import { AuthService } from "../services/auth.service";

@Component({
  selector: "app-register",
  templateUrl: "./register.component.html",
  styleUrls: ["./register.component.scss"],
  encapsulation: ViewEncapsulation.None,
})
export class RegisterComponent implements OnInit {
  registerForm: FormGroup;
  user: User;
  roles = [Role.Admin, Role.Seller, Role.Shopper];

  constructor(
    private formBuilder: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit() {
    this.registerForm = this.formBuilder.group(
      {
        username: ["", Validators.required],
        password: ["", Validators.required],
        secondPassword: ["", Validators.required],
        role: ["", Validators.required]
      },
      { validator: this.validateSecondPassword }
    );
  }

  onSubmit() {
    this.user = new User({
        username: this.registerForm.value.username,
        password: this.registerForm.value.password,
        role: this.registerForm.value.role
    });

    if (this.user) {
        this.authService.register(this.user)
            .subscribe(
                () => {
                    this.router.navigateByUrl('/login');
                }
            );
    }
}

  validateSecondPassword(group: FormGroup): ValidationErrors | null {
    const errors: ValidationErrors = [];

    const password = group.get("password");
    const secondPassword = group.get("secondPassword");

    if (password && secondPassword) {
      if (password.value === secondPassword.value) {
        return null;
      }
    }

    errors["notMatching"] = true;
    return errors;
  }
}
