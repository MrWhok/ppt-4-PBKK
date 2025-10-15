import { IsInt, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreatePostDto {
  // TODO: Implement post DTO with validation decorators
  @IsString()
  @IsNotEmpty()
  title: string;

  @IsString()
  @IsOptional()
  content?: string;

  @IsInt()
  @IsNotEmpty()
  authorId: number;
}
