import { IsNotEmpty, IsNumber } from 'class-validator';

export class CreateLikeDto {
  // TODO: Implement like DTO with validation decorators
    @IsNumber()
    @IsNotEmpty()
    userId: number;

    @IsNumber()
    @IsNotEmpty()
    postId: number;
}
